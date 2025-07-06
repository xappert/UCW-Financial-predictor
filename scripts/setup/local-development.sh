#!/bin/bash
# Financial Predictor - Local Development Setup Script

set -e

echo "🚀 Setting up Financial Predictor local development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_tools=()
    
    if ! command -v docker &> /dev/null; then
        missing_tools+=("Docker")
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        missing_tools+=("Docker Compose")
    fi
    
    if ! command -v node &> /dev/null; then
        missing_tools+=("Node.js")
    fi
    
    if ! command -v python3 &> /dev/null; then
        missing_tools+=("Python 3")
    fi
    
    if ! command -v poetry &> /dev/null; then
        print_warning "Poetry not found. Installing Poetry..."
        curl -sSL https://install.python-poetry.org | python3 -
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_error "Please install the missing tools and run this script again."
        exit 1
    fi
    
    print_success "All prerequisites are installed!"
}

# Create environment files
setup_environment_files() {
    print_status "Setting up environment files..."
    
    # Root environment file
    if [ ! -f .env.local ]; then
        cp .env.example .env.local 2>/dev/null || echo "# Environment variables for local development" > .env.local
    fi
    
    # API environment file
    if [ ! -f apps/api/.env.local ]; then
        cp apps/api/.env.example apps/api/.env.local
    fi
    
    # Web environment file
    if [ ! -f apps/web/.env.local ]; then
        cat > apps/web/.env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_ENVIRONMENT=development
NODE_ENV=development
EOF
    fi
    
    print_success "Environment files created!"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    # Install API dependencies
    print_status "Installing API dependencies..."
    cd apps/api
    poetry install
    cd ../..
    
    # Install Web dependencies
    print_status "Installing Web dependencies..."
    cd apps/web
    npm install
    cd ../..
    
    # Install root dependencies (if needed)
    if [ -f package.json ]; then
        print_status "Installing root dependencies..."
        npm install
    fi
    
    print_success "Dependencies installed!"
}

# Start development services
start_services() {
    print_status "Starting development services..."
    
    # Start database and Redis
    docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 30
    
    # Check if PostgreSQL is ready
    until docker exec financial-predictor-postgres-dev pg_isready -U dev_user -d financial_predictor_dev; do
        print_status "Waiting for PostgreSQL..."
        sleep 2
    done
    
    # Check if Redis is ready
    until docker exec financial-predictor-redis-dev redis-cli ping; do
        print_status "Waiting for Redis..."
        sleep 2
    done
    
    print_success "Development services are running!"
}

# Run database migrations
run_migrations() {
    print_status "Running database migrations..."
    
    cd apps/api
    
    # Initialize Alembic if not already done
    if [ ! -d "alembic" ]; then
        poetry run alembic init alembic
    fi
    
    # Run migrations
    poetry run alembic upgrade head 2>/dev/null || print_warning "No migrations to run yet"
    
    cd ../..
    
    print_success "Database setup completed!"
}

# Display service information
display_services() {
    print_success "Development environment setup complete!"
    echo ""
    echo -e "${GREEN}🌐 Available services:${NC}"
    echo "  - Frontend:     http://localhost:3000"
    echo "  - API:          http://localhost:8000"
    echo "  - API Docs:     http://localhost:8000/docs"
    echo "  - Database:     localhost:5432"
    echo "  - Redis:        localhost:6379"
    echo "  - PgAdmin:      http://localhost:5050"
    echo "  - Redis Admin:  http://localhost:8081"
    echo ""
    echo -e "${BLUE}🔧 Development commands:${NC}"
    echo "  - Start API:    cd apps/api && poetry run uvicorn app.main:app --reload"
    echo "  - Start Web:    cd apps/web && npm run dev"
    echo "  - Run tests:    cd apps/api && poetry run pytest"
    echo "  - View logs:    docker-compose -f infrastructure/docker/docker-compose.dev.yml logs -f"
    echo "  - Stop services: docker-compose -f infrastructure/docker/docker-compose.dev.yml down"
    echo ""
}

# Main execution
main() {
    check_prerequisites
    setup_environment_files
    install_dependencies
    start_services
    run_migrations
    display_services
}

# Run main function
main "$@"