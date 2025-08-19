const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand, GetCommand, PutCommand } = require('@aws-sdk/lib-dynamodb');
const { S3Client, PutObjectCommand, GetObjectCommand } = require('@aws-sdk/client-s3');
const { randomUUID } = require('crypto');
const fs = require('fs');
const path = require('path');

// Initialize AWS services
const dynamoDBClient = new DynamoDBClient({});
const dynamoDB = DynamoDBDocumentClient.from(dynamoDBClient);
const s3 = new S3Client({});

const TABLE_NAME = process.env.TABLE_NAME;
const BUCKET_NAME = process.env.BUCKET_NAME;
const BASE_URL = process.env.BASE_URL;

exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event, null, 2));

  const { resource, httpMethod, pathParameters, body } = event;

  try {
    // Route handling based on terraform configuration
    if (resource === '/blog' && httpMethod === 'GET') {
      return await getAllBlogPosts();
    }

    if (resource === '/blog/{id}' && httpMethod === 'GET') {
      const { id } = pathParameters;
      return await getBlogPostById(id);
    }

    if (resource === '/blog' && httpMethod === 'POST') {
      const postData = JSON.parse(body);
      return await createBlogPost(postData);
    }

    // Default response for unmatched routes
    return {
      statusCode: 404,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({ error: 'Route not found' })
    };

  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({ error: error.message })
    };
  }
};

// Get all blog posts
async function getAllBlogPosts() {
  try {
    const params = {
      TableName: TABLE_NAME,
      ScanIndexForward: false // Sort by creation date descending
    };

    const result = await dynamoDB.send(new ScanCommand(params));
    const posts = result.Items || [];

    // Load HTML template
    const templatePath = path.join(__dirname, 'blog-list.html');
    let htmlContent = fs.readFileSync(templatePath, 'utf8');

    // Generate posts HTML
    let postsHtml = '';
    let noPostsMessage = '';

    if (posts.length === 0) {
      noPostsMessage = '<div class="no-posts">No blog posts yet. Create the first one above!</div>';
    } else {
      postsHtml = posts.map(post => {
        const excerpt = post.content.length > 200 ? post.content.substring(0, 200) + '...' : post.content;
        const tagsHtml = post.tags && post.tags.length > 0
          ? post.tags.map(tag => `<span class="tag">${escapeHtml(tag)}</span>`).join('')
          : '';

        return `
          <div class="blog-post">
            <h2><a href="blog/${post.id}">${escapeHtml(post.title)}</a></h2>
            <div class="blog-meta">
              By ${escapeHtml(post.author || 'Anonymous')} • 
              ${formatDate(post.createdAt)} • 
              ${post.images && post.images.length > 0 ? post.images.length + ' image(s)' : 'No images'}
            </div>
            <div class="blog-excerpt">${escapeHtml(excerpt)}</div>
            ${tagsHtml ? `<div class="blog-tags">${tagsHtml}</div>` : ''}
          </div>
        `;
      }).join('');
    }

    // Replace placeholders
    htmlContent = htmlContent
      .replaceAll('{{BASE_URL}}', BASE_URL)
      .replace('{{TOTAL_POSTS}}', posts.length.toString())
      .replace('{{BLOG_POSTS_HTML}}', postsHtml)
      .replace('{{NO_POSTS_MESSAGE}}', noPostsMessage);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html',
        'Access-Control-Allow-Origin': '*'
      },
      body: htmlContent
    };
  } catch (error) {
    console.error('Error getting blog posts:', error);
    throw error;
  }
}

// Get blog post by ID
async function getBlogPostById(id) {
  try {
    if (!id) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'text/html',
          'Access-Control-Allow-Origin': '*'
        },
        body: '<h1>Error: Post ID is required</h1><a href="/blog">← Back to Blog</a>'
      };
    }

    const params = {
      TableName: TABLE_NAME,
      Key: { pk: id, sk: 'POST' }
    };

    const result = await dynamoDB.send(new GetCommand(params));

    // Load HTML template
    const templatePath = path.join(__dirname, 'blog-post.html');
    let htmlContent = fs.readFileSync(templatePath, 'utf8');

    if (!result.Item) {
      // Replace with not found content
      htmlContent = htmlContent
        .replaceAll('{{BASE_URL}}', escapeHtml(BASE_URL))
        .replaceAll('{{POST_TITLE}}', 'Post Not Found')
        .replace('{{POST_NOT_FOUND}}', `
          <div class="post-not-found">
            <h2>Blog Post Not Found</h2>
            <p>The post with ID "${escapeHtml(id)}" could not be found.</p>
          </div>
        `)
        .replace('{{POST_AUTHOR}}', '')
        .replace('{{POST_CREATED_DATE}}', '')
        .replace('{{POST_UPDATED_DATE}}', '')
        .replace('{{POST_ID}}', '')
        .replace('{{POST_CONTENT}}', '')
        .replace('{{POST_IMAGES_SECTION}}', '')
        .replace('{{POST_TAGS_SECTION}}', '');

      return {
        statusCode: 404,
        headers: {
          'Content-Type': 'text/html',
          'Access-Control-Allow-Origin': '*'
        },
        body: htmlContent
      };
    }

    const post = result.Item;

    // Generate images section
    let imagesSection = '';
    if (post.images && post.images.length > 0) {
      const imagesHtml = post.images.map(image => `
        <div class="image-item">
          <img src="${image.url}" alt="${escapeHtml(image.originalName)}" loading="lazy">
          <div class="image-info">
            <p><strong>Name:</strong> ${escapeHtml(image.originalName)}</p>
            <p><strong>Uploaded:</strong> ${formatDate(image.uploadedAt)}</p>
          </div>
        </div>
      `).join('');

      imagesSection = `
        <div class="post-images">
          <h3>Images (${post.images.length})</h3>
          <div class="image-gallery">
            ${imagesHtml}
          </div>
        </div>
      `;
    }

    // Generate tags section
    let tagsSection = '';
    if (post.tags && post.tags.length > 0) {
      const tagsHtml = post.tags.map(tag => `<span class="tag">${escapeHtml(tag)}</span>`).join('');
      tagsSection = `
        <div class="post-tags">
          <h3>Tags</h3>
          ${tagsHtml}
        </div>
      `;
    }

    // Replace placeholders
    htmlContent = htmlContent
      .replaceAll('{{BASE_URL}}', escapeHtml(BASE_URL))
      .replaceAll('{{POST_TITLE}}', escapeHtml(post.title))
      .replace('{{POST_NOT_FOUND}}', '')
      .replace('{{POST_AUTHOR}}', escapeHtml(post.author || 'Anonymous'))
      .replace('{{POST_CREATED_DATE}}', formatDate(post.createdAt))
      .replace('{{POST_UPDATED_DATE}}', formatDate(post.updatedAt))
      .replace('{{POST_ID}}', escapeHtml(post.id))
      .replace('{{POST_CONTENT}}', escapeHtml(post.content))
      .replace('{{POST_IMAGES_SECTION}}', imagesSection)
      .replace('{{POST_TAGS_SECTION}}', tagsSection);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html',
        'Access-Control-Allow-Origin': '*'
      },
      body: htmlContent
    };
  } catch (error) {
    console.error('Error getting blog post by ID:', error);
    throw error;
  }
}

// Create new blog post
async function createBlogPost(postData) {
  try {
    const { title, content, author, tags = [], images = [] } = postData;

    if (!title || !content) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: JSON.stringify({
          error: 'Title and content are required'
        })
      };
    }

    const postId = randomUUID();
    const timestamp = new Date().toISOString();

    // Process images if provided
    const processedImages = [];
    if (images && images.length > 0) {
      for (const image of images) {
        const imageUrl = await uploadImageToS3(image, postId);
        processedImages.push({
          id: randomUUID(),
          url: imageUrl,
          originalName: image.name || 'untitled',
          uploadedAt: timestamp
        });
      }
    }

    const blogPost = {
      pk: postId,
      sk: 'POST',
      id: postId,
      title,
      content,
      author: author || 'Anonymous',
      tags,
      images: processedImages,
      createdAt: timestamp,
      updatedAt: timestamp,
      published: true
    };

    const params = {
      TableName: TABLE_NAME,
      Item: blogPost
    };

    await dynamoDB.send(new PutCommand(params));

    return {
      statusCode: 201,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        message: 'Blog post created successfully',
        post: blogPost
      })
    };
  } catch (error) {
    console.error('Error creating blog post:', error);
    throw error;
  }
}

// Upload image to S3
async function uploadImageToS3(imageData, postId) {
  try {
    const { data, name, type } = imageData;

    // Convert base64 to buffer if needed
    const buffer = Buffer.isBuffer(data) ? data : Buffer.from(data, 'base64');

    const key = `posts/${postId}/images/${randomUUID()}`;

    const uploadParams = {
      Bucket: BUCKET_NAME,
      Key: key,
      Body: buffer,
      ContentType: type || 'image/jpeg',
      ACL: 'public-read'
    };

    await s3.send(new PutObjectCommand(uploadParams));
    return `https://${BUCKET_NAME}.s3.amazonaws.com/${key}`;
  } catch (error) {
    console.error('Error uploading image to S3:', error);
    throw error;
  }
}

// Utility functions
function escapeHtml(unsafe) {
  if (!unsafe) return '';
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function formatDate(dateString) {
  if (!dateString) return '';
  try {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  } catch (error) {
    return dateString;
  }
}

// Get image from S3 (helper function for future use)
async function getImageFromS3(key) {
  try {
    const params = {
      Bucket: BUCKET_NAME,
      Key: key
    };

    const result = await s3.send(new GetObjectCommand(params));
    return result.Body;
  } catch (error) {
    console.error('Error getting image from S3:', error);
    throw error;
  }
}
