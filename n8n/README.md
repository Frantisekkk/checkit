# n8n Workflow for Checkit

This folder contains the n8n workflow automation for AI-powered video analysis. The workflow integrates with AI services to provide real content analysis for the Checkit platform.

---

## 📋 Overview

The n8n workflow automates the video analysis pipeline by:
1. Receiving video URLs via webhook
2. Processing the video content
3. Calling AI services (OpenAI, Anthropic, etc.)
4. Returning formatted analysis results

This provides a no-code/low-code way to integrate multiple AI services and create complex analysis workflows.

---

## 🎯 What is n8n?

[n8n](https://n8n.io/) is a workflow automation platform that allows you to connect different services and APIs without writing code. It's like Zapier but open-source and self-hosted.

**Key Features:**
- Visual workflow builder
- 400+ integrations
- Self-hosted (full data control)
- Custom code execution (JavaScript/Python)
- Webhook support
- Error handling and retry logic

---

## 🚀 Getting Started

### Prerequisites

- Docker (recommended) or Node.js 18+
- Port 5678 available (default n8n port)

### Installation Options

#### Option 1: Docker (Recommended)

```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

#### Option 2: npm

```bash
npm install n8n -g
n8n start
```

#### Option 3: Docker Compose

Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=your_password
    volumes:
      - ~/.n8n:/home/node/.n8n
```

Run:
```bash
docker-compose up -d
```

---

## 📥 Import Workflow

1. **Access n8n:**
   - Open http://localhost:5678
   - Create an account or log in

2. **Import the workflow:**
   - Click "Import from File"
   - Select `n8n_flow.json` from this folder
   - Click "Import"

3. **Configure credentials:**
   - Click on nodes that need credentials
   - Add your API keys (OpenAI, Anthropic, etc.)
   - Save the workflow

4. **Activate the workflow:**
   - Toggle the "Active" switch in the top right
   - The webhook endpoint is now live

---

## 🔧 Workflow Configuration

### Webhook Endpoint

After importing, note your webhook URL:
```
https://your-n8n-instance.com/webhook/6129cb38-d880-4def-8b67-40755e8a3f5a
```

Or for local testing:
```
http://localhost:5678/webhook-test/6129cb38-d880-4def-8b67-40755e8a3f5a
```

### Connect to Backend

Update the backend to use the n8n workflow:

**Option A: Direct Integration**

In `backend/app.py`, modify the `analyze_video()` function:

```python
import requests

def analyze_video_with_n8n(url, analysis_type):
    n8n_webhook = os.getenv('N8N_WEBHOOK_URL')
    
    response = requests.post(n8n_webhook, json={
        'url': url,
        'type': analysis_type
    })
    
    return response.json()
```

**Option B: Backend as Proxy**

Keep the backend endpoints but forward to n8n for actual processing.

Add to `backend/.env`:
```bash
N8N_WEBHOOK_URL=http://localhost:5678/webhook/YOUR_WEBHOOK_ID
USE_N8N_FOR_ANALYSIS=true
```

---

## 🏗️ Workflow Structure

The workflow typically includes these nodes:

### 1. Webhook Node
- **Purpose:** Receive incoming requests from backend
- **Configuration:**
  - Method: POST
  - Path: Auto-generated unique ID
  - Response Mode: "Respond When Last Node Finishes"

### 2. Data Processing Node
- **Purpose:** Extract and validate video URL
- **Configuration:**
  - Parse JSON body
  - Extract URL and analysis type
  - Validate inputs

### 3. Video Analysis Nodes

#### Option A: OpenAI (GPT-4 Vision)
```
Webhook → Download Video Frame → GPT-4 Vision → Format Response
```

#### Option B: Anthropic Claude
```
Webhook → Extract Transcript → Claude API → Format Response
```

#### Option C: Custom AI Pipeline
```
Webhook → YouTube-DL → Frame Extraction → Multiple AI Services → Aggregate → Response
```

### 4. Error Handling
- Catch errors at each step
- Return formatted error messages
- Log failures for debugging

### 5. Response Node
- Format final response
- Return to backend/client

---

## 🎨 Customizing the Workflow

### Add New Analysis Types

1. Add an "IF" node to check analysis type
2. Route to different processing branches
3. Implement custom logic for each type

### Integrate Additional AI Services

Popular integrations:
- **OpenAI** - GPT-4, DALL-E
- **Anthropic** - Claude
- **Google** - Gemini
- **Hugging Face** - Various models
- **Stable Diffusion** - Image generation
- **ElevenLabs** - Text-to-speech

### Add Fact-Checking Database

```
Video URL → Extract Claims → Query Fact-Check API → Compare → Return Results
```

Example services:
- Google Fact Check API
- ClaimReview structured data
- Custom fact-check database

---

## 🧪 Testing the Workflow

### Test in n8n Interface

1. Click "Execute Workflow" button
2. Manually trigger with test data
3. View execution results in real-time

### Test via Webhook

```bash
# Test webhook endpoint
curl -X POST http://localhost:5678/webhook-test/YOUR_WEBHOOK_ID \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "type": "hoax"
  }'
```

### Expected Response

```json
{
  "status": "success",
  "type": "hoax",
  "response": "Analysis results from AI...",
  "metadata": {
    "processing_time": 2.5,
    "ai_model": "gpt-4-vision",
    "confidence": 0.85
  }
}
```

---

## 🔐 Security & Best Practices

### 1. Secure Webhook Endpoints

Add authentication:
- Use webhook authentication in n8n
- Add API key validation
- Implement request signing

### 2. Protect API Keys

- Never commit API keys
- Use n8n credentials manager
- Rotate keys regularly
- Use environment variables

### 3. Rate Limiting

Add rate limiting nodes:
- Check request frequency
- Implement queue system
- Return 429 status for exceeded limits

### 4. Data Privacy

- Don't log sensitive data
- Encrypt data in transit
- Delete video content after processing
- Comply with GDPR/privacy laws

---

## 📊 Monitoring & Debugging

### View Execution History

1. In n8n, go to "Executions"
2. View past workflow runs
3. Inspect input/output data
4. Check for errors

### Enable Debug Logging

In workflow settings:
- Enable "Save Execution Progress"
- Enable "Save Manual Executions"

### Monitor Performance

Key metrics:
- Execution time
- Success/failure rate
- API response times
- Error types

---

## 🚀 Production Deployment

### Self-Hosted Options

#### 1. VPS (DigitalOcean, Linode, AWS EC2)

```bash
# Install n8n
npm install n8n -g

# Set up as service
sudo nano /etc/systemd/system/n8n.service
```

Service file:
```ini
[Unit]
Description=n8n
After=network.target

[Service]
Type=simple
User=n8n
ExecStart=/usr/bin/n8n start
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
# Start service
sudo systemctl enable n8n
sudo systemctl start n8n
```

#### 2. n8n Cloud (Managed Hosting)

- Visit https://n8n.io/cloud/
- Sign up for managed hosting
- Import workflow
- No server management needed

#### 3. Docker in Production

```yaml
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=n8n.yourdomain.com
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://n8n.yourdomain.com/
    volumes:
      - ./n8n_data:/home/node/.n8n
    restart: unless-stopped
```

### SSL/HTTPS Setup

Use nginx as reverse proxy:

```nginx
server {
    listen 80;
    server_name n8n.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name n8n.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/n8n.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/n8n.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## 💡 Workflow Examples

### Example 1: Simple Hoax Check

```
Webhook
  ↓
Extract URL
  ↓
Get Video Transcript (YouTube API)
  ↓
Send to GPT-4 with Prompt:
"Analyze this video transcript for misinformation"
  ↓
Format Response
  ↓
Return to Client
```

### Example 2: Multi-AI Analysis

```
Webhook
  ↓
Download Video
  ↓
  ├─→ GPT-4 Vision (Visual Analysis)
  ├─→ Whisper (Audio Transcript)
  └─→ Claude (Text Analysis)
  ↓
Merge Results
  ↓
Return Combined Analysis
```

### Example 3: Fact-Check Pipeline

```
Webhook
  ↓
Extract Claims (NLP)
  ↓
For Each Claim:
  ├─→ Google Fact Check API
  ├─→ Wikipedia Search
  └─→ News API Search
  ↓
Score Claims (Credibility)
  ↓
Generate Report
  ↓
Return Results
```

---

## 🐛 Troubleshooting

### Webhook Not Responding

**Check:**
- Workflow is activated (toggle in UI)
- Correct webhook URL
- n8n is running
- Firewall allows port 5678

**Test:**
```bash
curl http://localhost:5678/webhook-test/YOUR_ID
```

### API Rate Limits

**Solutions:**
- Implement caching
- Add queue system
- Use multiple API keys
- Switch to different AI provider

### Workflow Execution Errors

**Debug steps:**
1. Check execution log in n8n
2. Verify node configurations
3. Test each node individually
4. Check API credentials
5. Review error messages

---

## 📚 Resources

### Official Documentation
- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [n8n GitHub](https://github.com/n8n-io/n8n)

### Tutorials
- [n8n Getting Started Guide](https://docs.n8n.io/getting-started/)
- [Building Workflows](https://docs.n8n.io/workflows/)
- [Custom Nodes](https://docs.n8n.io/nodes/)

### AI Service Docs
- [OpenAI API](https://platform.openai.com/docs)
- [Anthropic Claude](https://docs.anthropic.com/)
- [Hugging Face](https://huggingface.co/docs)

---

## 🔮 Future Enhancements

### Planned Features
- [ ] Multi-language support for video analysis
- [ ] Video content moderation
- [ ] Trend detection across multiple videos
- [ ] Automated fact-checking against multiple sources
- [ ] Sentiment analysis
- [ ] Speaker identification
- [ ] Object detection in video frames

### Integration Ideas
- **Telegram Bot** - Share videos via Telegram
- **Discord Bot** - Analyze shared videos in Discord
- **Chrome Extension** - Right-click analyze on any video
- **API Gateway** - Provide API for third-party apps

---

## 💰 Cost Considerations

### AI API Costs

Estimated per request:
- **GPT-4 Vision**: $0.01 - $0.05
- **Claude**: $0.008 - $0.024
- **Whisper (transcription)**: $0.006/minute

### n8n Hosting

- **Self-hosted**: Free (only server costs)
- **n8n Cloud**: Starting at $20/month

### Example Monthly Costs (10,000 analyses)

```
Scenario: GPT-4 Vision Analysis
- AI API: $300 (10,000 × $0.03)
- n8n Cloud: $20
- Total: ~$320/month

Scenario: Self-hosted with Claude
- AI API: $120 (10,000 × $0.012)
- VPS: $10
- Total: ~$130/month
```

---

## 🤝 Contributing

To modify the workflow:

1. Make changes in n8n UI
2. Export workflow (Menu → Export → JSON)
3. Save to `n8n_flow.json`
4. Test thoroughly
5. Document changes in this README
6. Commit to repository

---

## 📞 Support

For n8n-specific issues:
- [n8n Community Forum](https://community.n8n.io/)
- [n8n Discord](https://discord.gg/n8n)
- [GitHub Issues](https://github.com/n8n-io/n8n/issues)

For workflow-specific questions:
- Check this README
- Review workflow execution logs
- Test individual nodes

---

**Part of the Checkit project for Hackathon 2025 Telcom**


