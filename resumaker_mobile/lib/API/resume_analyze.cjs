const express = require('express');
const fileUpload = require('express-fileupload');
const fs = require('fs');
const path = require('path');
const pdfParse = require('pdf-parse');
const dotenv = require('dotenv');
const OpenAI = require("openai");

// Load environment variables
dotenv.config();

const openaiApiKey = process.env.OPENAI_API_KEY;
if (!openaiApiKey) {
    throw new Error("API key missing.");
}

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
});

const app = express();

console.log("Express app starting...");

// Upload Config
const UPLOAD_FOLDER = 'uploads';
if (!fs.existsSync(UPLOAD_FOLDER)) {
    fs.mkdirSync(UPLOAD_FOLDER);
}
app.use(fileUpload({
    limits: { fileSize: 2 * 1024 * 1024 }, // Limit file size to 2MB
    useTempFiles: true,
    tempFileDir: UPLOAD_FOLDER
}));

// Allowed Extensions
const ALLOWED_EXTENSIONS = ['pdf', 'txt'];

function allowedFile(filename) {
    const ext = path.extname(filename).toLowerCase().substring(1);
    return ALLOWED_EXTENSIONS.includes(ext);
}

async function extractTextFromPdf(pdfPath) {
    try {
        const dataBuffer = fs.readFileSync(pdfPath);
        const data = await pdfParse(dataBuffer);
        return data.text.trim() || "No extractable text found.";
    } catch (e) {
        return `Error extracting text: ${e.message}`;
    }
}

app.post('/analyze-resume', async (req, res) => {
    console.log("Analyzing resume...");

    if (!req.files || !req.files.file) {
        console.log("No file in request.");
        return res.status(400).json({ error: "No file uploaded" });
    }

    const file = req.files.file;
    console.log(`File received: ${file.name}`);

    if (file && allowedFile(file.name)) {
        const filepath = path.join(UPLOAD_FOLDER, file.name);
        await file.mv(filepath);

        console.log(`File saved at: ${filepath}`);

        let resumeText;
        if (file.name.endsWith('.pdf')) {
            resumeText = await extractTextFromPdf(filepath);
        } else {
            resumeText = fs.readFileSync(filepath, 'utf-8');
        }

        console.log("Extracted resume text.");

        // OpenAI prompt
        const prompt = `
            You are an expert career coach and resume reviewer. Analyze the following resume and provide structured feedback with the following criteria:

            1. **Overall Score**: Provide a numerical score (0-100) based on the resume's effectiveness.
            2. **Keyword Match**: Estimate how well the resume aligns with typical job descriptions (percentage 0-100%).
            3. **Formatting**: Assess clarity, readability, and structure (percentage 0-100%).
            4. **Content Quality**: Evaluate grammar, conciseness, and overall professionalism (percentage 0-100%).
            5. **Suggestions for Improvement**: Provide three key bullet points on what the candidate should improve.

            Resume:
            ----------------------
            ${resumeText}
            ----------------------

            Respond strictly in the following JSON format:
            {
            "overall_score": 85,
            "keyword_match": 90,
            "formatting": 80,
            "content_quality": 75,
            "suggestions": [
                "Improve formatting in the skills section",
                "Use more action-oriented language",
                "Add measurable achievements"
            ]
            }
            `;


            try {
                const response = await openai.chat.completions.create({
                    model: "gpt-4",
                    messages: [
                        { role: "system", content: "You are an expert career coach and resume reviewer." },
                        { role: "user", content: prompt }
                    ],
                    temperature: 0.5
                });
            
                console.log("Full OpenAI response:", response);
            
                if (!response || !response.choices || response.choices.length === 0) {
                    throw new Error("Invalid response from OpenAI");
                }
            
                // Parse response as JSON
                const feedback = JSON.parse(response.choices[0].message.content.trim());
            
                console.log("Feedback generated:", feedback);
            
                fs.unlinkSync(filepath); // Remove file after processing
                return res.json(feedback);
            
            } catch (e) {
                console.error("Error in OpenAI API call:", e.response ? e.response.data : e.message);
                fs.unlinkSync(filepath);
                return res.status(500).json({ error: `Failed to generate feedback: ${e.message}` });
        }
    }

    return res.status(400).json({ error: "Invalid file type. Only PDF or TXT allowed." });
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});