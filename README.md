# Directus Template

This repository serves as a starting point for Directus projects, providing a minimal setup with Docker and scripts for managing snapshots. It is designed to be lightweight and customizable, making it ideal for building and extending Directus-based projects.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/lab-do/directus-template.git directus
cd directus
```

### Build and Start Directus

Use Docker Compose to build and start the Directus container:

```bash
docker-compose up -d
```

This will start a Directus instance accessible at `http://localhost:8055` (default port). Adjust the port in `docker-compose.yml` if needed.

### Accessing Directus

Once the container is running, you can access the Directus admin panel at:

```
http://localhost:8055
```

The default login credentials can be set in the `.env` file or configured manually during the first-time setup.

## Snapshot Management

This template includes scripts to manage Directus snapshots for saving and applying configurations. Snapshots allow you to back up the current state of your Directus instance or migrate configurations to another instance.

### Save a Snapshot

Run the following script to save the current configuration:

```bash
./scripts/save-snapshot.sh
```

This will generate a snapshot file in the snapshots/ directory with the format `snapshot_YYYYMMDD_HHMMSS.yaml` and update the `snapshots-latest.yaml` file.

### Apply a Snapshot

To apply a saved snapshot, use the following command:

```bash
./scripts/apply-snapshot.sh <snapshot-file-name>
```

- Replace `<snapshot-file-name>` with the name of the snapshot file you want to apply (e.g., `snapshot-file.yaml`).
- The script will look for the file in the `snapshot` folder.
- If no file name is provided, the script will default to using `snapshot-latest.yaml` from the `snapshot` folder.

## Directory Structure

```
.
├── Dockerfile             # Directus Docker image configuration
├── docker-compose.yml     # Docker Compose setup
├── scripts/               # Scripts for snapshot management
│   ├── save-snapshot.sh   # Save Directus snapshot
│   └── apply-snapshot.sh  # Apply Directus snapshot
├── snapshots/             # Directory to store snapshots
└── README.md              # Project documentation
```

## License

This project is licensed under the MIT License.
