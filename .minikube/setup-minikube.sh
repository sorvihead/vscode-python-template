#!/bin/bash
# Minikube setup script for Python template development environment
# Creates an isolated Minikube cluster with project-specific configuration

set -e

# Configuration
PROFILE_NAME="dev-template-env"
DRIVER="podman"
MEMORY="4000"
CPUS="2"
DISK_SIZE="20g"
KUBERNETES_VERSION="v1.28.0"
CONTAINER_RUNTIME="docker"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if required tools are installed
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v minikube &> /dev/null; then
        log_error "Minikube not found. Please install minikube first."
        echo "   macOS: brew install minikube"
        echo "   Linux: curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
        exit 1
    fi
    
    if ! command -v podman &> /dev/null; then
        log_error "Podman not found. Please install podman first."
        echo "   macOS: brew install podman"
        echo "   Linux: apt-get install podman / yum install podman"
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        log_warning "kubectl not found. Installing via minikube..."
        minikube kubectl -- version --client || true
    fi
    
    log_success "Prerequisites check completed"
}

# Check if profile exists
check_profile_exists() {
    local profile_count
    profile_count=$(minikube profile list 2>/dev/null | grep -c "${PROFILE_NAME}" 2>/dev/null || echo "0")
    if [ "$profile_count" -gt 0 ] 2>/dev/null; then
        return 0  # Profile exists
    else
        return 1  # Profile doesn't exist
    fi
}

# Get current profile status
get_profile_status() {
    if check_profile_exists; then
        local status
        # Get the host status from minikube status output
        status=$(minikube status --profile="${PROFILE_NAME}" 2>/dev/null | grep "host:" | cut -d: -f2 | tr -d ' ' || echo "Unknown")
        if [ -z "$status" ]; then
            # Fallback: try to get status differently
            status=$(minikube status --profile="${PROFILE_NAME}" --format='{{.Host}}' 2>/dev/null || echo "Unknown")
        fi
        echo "${status}"
    else
        echo "NotFound"
    fi
}

# Display profile information
show_profile_info() {
    log_info "Profile Information:"
    echo "  Name: ${PROFILE_NAME}"
    echo "  Driver: ${DRIVER}"
    echo "  Container Runtime: ${CONTAINER_RUNTIME}"
    echo "  Memory: ${MEMORY}MB"
    echo "  CPUs: ${CPUS}"
    echo "  Disk: ${DISK_SIZE}"
    echo "  Kubernetes: ${KUBERNETES_VERSION}"
    echo ""
}

# Start Minikube cluster
start_minikube() {
    log_info "Starting Minikube cluster with profile '${PROFILE_NAME}'..."
    
    minikube start \
        --profile="${PROFILE_NAME}" \
        --driver="${DRIVER}" \
        --memory="${MEMORY}" \
        --cpus="${CPUS}" \
        --disk-size="${DISK_SIZE}" \
        --kubernetes-version="${KUBERNETES_VERSION}" \
        --container-runtime="${CONTAINER_RUNTIME}" \
        --auto-update-drivers=false
    
    # Set as active profile
    minikube profile "${PROFILE_NAME}"
    
    log_success "Minikube cluster started successfully"
}

# Setup required addons
setup_addons() {
    log_info "Configuring addons..."
    
    # Set profile context
    minikube profile "${PROFILE_NAME}"
    
    # Enable ingress addon
    log_info "Enabling ingress addon..."
    minikube addons enable ingress --profile="${PROFILE_NAME}"
    
    # Enable auto-pause addon
    log_info "Enabling auto-pause addon..."
    minikube addons enable auto-pause --profile="${PROFILE_NAME}"
    
    # Enable metrics server (useful for development)
    log_info "Enabling metrics-server addon..."
    minikube addons enable metrics-server --profile="${PROFILE_NAME}"
    
    # Enable dashboard (optional but useful)
    log_info "Enabling dashboard addon..."
    minikube addons enable dashboard --profile="${PROFILE_NAME}"
    
    # Wait a moment for addons to initialize
    log_info "Waiting for addons to initialize..."
    sleep 10
    
    log_success "Addons configured successfully"
}

# Verify cluster health
verify_cluster() {
    log_info "Verifying cluster health..."
    
    # Set profile context and update kubectl
    minikube profile "${PROFILE_NAME}"
    
    # Wait for cluster to be ready
    local retries=30
    local count=0
    
    log_info "Waiting for cluster to be ready..."
    while [ $count -lt $retries ]; do
        if minikube status --profile="${PROFILE_NAME}" | grep -q "apiserver: Running"; then
            log_success "Kubernetes API server is ready"
            break
        fi
        count=$((count + 1))
        log_info "Waiting for cluster... ($count/$retries)"
        sleep 3
    done
    
    if [ $count -eq $retries ]; then
        log_error "Cluster failed to become ready"
        minikube status --profile="${PROFILE_NAME}" || true
        return 1
    fi
    
    # Basic cluster verification
    log_info "Cluster status:"
    minikube status --profile="${PROFILE_NAME}"
    
    log_success "Cluster verification completed"
}

# Show useful commands and information
show_usage_info() {
    log_success "Minikube environment is ready!"
    echo ""
    echo "Useful commands:"
    echo "  📊 Cluster status:    minikube status --profile=${PROFILE_NAME}"
    echo "  🌐 Dashboard:         minikube dashboard --profile=${PROFILE_NAME}"
    echo "  🐳 Docker env:        eval \$(minikube docker-env --profile=${PROFILE_NAME})"
    echo "  ⏹️  Stop cluster:      minikube stop --profile=${PROFILE_NAME}"
    echo "  🗑️  Delete cluster:    minikube delete --profile=${PROFILE_NAME}"
    echo ""
    echo "Troubleshooting:"
    echo "  📋 Cluster info:      ./.minikube/setup-minikube.sh info"
    echo "  🔍 Update context:    minikube update-context --profile=${PROFILE_NAME}"
    echo "  🔧 Reset cluster:     minikube delete --profile=${PROFILE_NAME} && make minikube-setup"
    echo ""
    echo "Next steps:"
    echo "  1. Build your Docker image: make docker-build"
    echo "  2. Deploy to Kubernetes: kubectl apply -f your-manifests/"
    echo "  3. Access services: minikube service <service-name> --profile=${PROFILE_NAME}"
}

# Main function
main() {
    echo ""
    log_info "🚀 Minikube Setup for Python Template Development"
    echo ""
    
    show_profile_info
    check_prerequisites
    
    local status
    status=$(get_profile_status)
    
    case "${status}" in
        "NotFound")
            log_info "Profile '${PROFILE_NAME}' not found. Creating new cluster..."
            start_minikube
            setup_addons
            verify_cluster
            ;;
        "Running")
            log_success "Profile '${PROFILE_NAME}' is already running"
            log_info "Checking addons configuration..."
            setup_addons  # Ensure addons are enabled
            verify_cluster
            ;;
        "Stopped")
            log_info "Profile '${PROFILE_NAME}' exists but is stopped. Starting..."
            minikube start --profile="${PROFILE_NAME}"
            setup_addons  # Ensure addons are enabled
            verify_cluster
            ;;
        *)
            log_warning "Profile '${PROFILE_NAME}' status: ${status}"
            log_info "Attempting to start cluster..."
            minikube start --profile="${PROFILE_NAME}"
            setup_addons
            verify_cluster
            ;;
    esac
    
    show_usage_info
}

# Handle script arguments
case "${1:-}" in
    "status")
        if check_profile_exists; then
            echo "Profile Status:"
            minikube status --profile="${PROFILE_NAME}"
        else
            echo "Profile '${PROFILE_NAME}' does not exist"
            exit 1
        fi
        ;;
    "info")
        if check_profile_exists; then
            show_profile_info
            if [ "$(get_profile_status)" = "Running" ]; then
                verify_cluster
            fi
        else
            echo "Profile '${PROFILE_NAME}' does not exist"
            exit 1
        fi
        ;;
    *)
        main "$@"
        ;;
esac

# Handle script interruption
trap 'log_error "Script interrupted"; exit 1' INT TERM
