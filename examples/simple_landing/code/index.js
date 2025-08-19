const fs = require('fs');
const path = require('path');

exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event, null, 2));

  const resource = event.resource;

  try {
    if (resource === '/') {
      return landingPage();
    }
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};

function landingPage() {
  try {
    const htmlPath = path.join(__dirname, 'index.html');
    const htmlContent = fs.readFileSync(htmlPath, 'utf8');

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body: htmlContent
    };
  } catch (error) {
    console.error('Error reading HTML file:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Could not load page' })
    };
  }
}
