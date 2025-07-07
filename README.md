# FinTrack - Personal Financial Analytics

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

FinTrack is a modern financial analytics platform that transforms your financial data into actionable insights. Built with Next.js, TypeScript, and Python, it provides intuitive tools for budget tracking, investment analysis, debt management, and financial goal planning.

## Key Features

- 📊 **Budget Tracking**: Monitor spending patterns and identify saving opportunities
- 📈 **Investment Analysis**: Evaluate portfolio performance with advanced visualizations
- 📉 **Debt Management**: Create payoff strategies and track progress
- 🎯 **Goal Planning**: Set and achieve financial milestones
- 🛡️ **Risk Assessment**: Understand your financial vulnerability factors
- 🔐 **Secure Authentication**: Role-based access control with JWT tokens
- 💻 **Responsive Design**: Works seamlessly across desktop and mobile devices

## Tech Stack

### Frontend
- **Framework**: Next.js 13 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS with CSS Variables
- **UI Components**: Radix UI + Shadcn
- **State Management**: React Context + Zustand
- **Form Handling**: React Hook Form

### Backend
- **Language**: Python
- **Framework**: FastAPI
- **Database**: PostgreSQL
- **Caching**: Redis
- **Auth**: JWT-based authentication
- **Deployment**: Google Cloud Run

### Infrastructure
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker
- **CI/CD**: Google Cloud Build
- **Monitoring**: Google Cloud Operations Suite

## Getting Started

### Prerequisites
- Node.js 18+
- Python 3.10+
- Docker
- Terraform

### Installation
```bash
# Clone repository
git clone https://github.com/your-username/UCW-Financial-predictor.git
cd UCW-Financial-predictor

# Install dependencies
npm install

# Start development servers
npm run dev
```

### Environment Setup
1. Copy `.env.example` to `.env` in both `apps/web` and `apps/api` directories
2. Update environment variables with your configuration
3. Start the development stack:
```bash
docker-compose -f infrastructure/docker/docker-compose.dev.yml up
```

## Project Structure
```
├── apps
│   ├── api/          # FastAPI backend
│   └── web/          # Next.js frontend
├── infrastructure/   # Terraform and Docker configs
├── docs/             # Technical documentation
└── scripts/          # Development and deployment scripts
```

## Contributing

We welcome contributions! Please follow these steps:
1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
