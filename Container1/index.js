 
const express = require('express');
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
dotenv.config();
const app = express();
const PORT = process.env.PORT;

// Middleware to parse incoming JSON
app.use(express.json());

// Endpoint to receive input and forward it to the second container
app.post('/calculate', (req, res) => {
    const { file, product } = req.body;

    // Check for invalid input
    if (!file || !product || file.trim() === '' || product.trim() === '') {
        return res.status(400).json({
            file: null,
            error: 'Invalid JSON input.'
        });
    }

    const filePath = path.join(__dirname, "files", file);

    // Check if the file exists
    if (!fs.existsSync(filePath)) {
        return res.status(404).json({
            file: file,
            error: 'File not found.'
        });
    }

    // Forward the request to the second container
    axios.post('http://second-service:3001/calculate-sum', { file, product })

        .then(response => res.json(response.data))
        .catch(error => {
            if (error.response) {
                res.status(error.response.status).json(error.response.data);
            } else {
                res.status(500).json({ error: 'api call fails' });
            }
        });
});

// Start the server
app.listen(PORT, () => {
    console.log(`App container listening on port ${PORT}`);
});
