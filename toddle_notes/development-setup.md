# Development Setup

## Local Environment Setup

### Prerequisites
- Docker Desktop (latest version)
- Node.js v16+
- Git
- VS Code (recommended)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/toddle.git
   cd toddle
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your local configuration
   ```

4. **Start the development server**
   ```bash
   npm run dev
   ```

5. **Access the application**
   - Frontend: http://localhost:3000
   - API: http://localhost:8080
   - Documentation: http://localhost:8090

## Docker Setup

### Using Docker Compose

1. **Build and start containers**
   ```bash
   docker-compose up -d
   ```

2. **Stop containers**
   ```bash
   docker-compose down
   ```

### Docker Volumes

We use the following volumes for data persistence:
- `obsidian_data`: For Obsidian notes and configuration
- `postgres_data`: For database persistence
- `redis_data`: For cache persistence

## VS Code Configuration

Recommended extensions:
- ESLint
- Prettier
- Docker
- GitLens
- Obsidian Tools

## Obsidian Integration

Our documentation is maintained in Obsidian. To access it:

1. **Run Obsidian in Docker**
   ```bash
   ./obsidian.sh start
   ```

2. **Access via browser**
   - Open http://localhost:3000

## Links
- [[project-overview|Back to Project Overview]]
- [[troubleshooting|Common Issues & Solutions]]
- [[index|Back to Index]]

## Tags
#development #setup #docker #obsidian
