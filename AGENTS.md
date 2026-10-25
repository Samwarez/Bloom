# Bloom working instructions

Read README.md and local/installer/README.md before changing the application.
Bloom is the installer; PetalOS remains the OS and catalog/storage format.
Preserve private-pipe credential handling, target identity checks, source
verification, explicit destructive confirmation, and fail-closed mount checks.
Never include personal credentials, VPN profiles, keys, disk images or backups
in the source or release artifacts. Physical-media operations require separate
explicit user instructions; source publication does not authorize them.

Run the local installer unit tests for code changes and native GTK tests when
changing the interface. Build the package and verify the portable runtime for
release changes. Never infer hardware acceptance from a synthetic VM fixture.
Keep source paths compatible with the package/portable builders. Stage explicit
paths, inspect exact staged blobs and run scripts/check-staged-content.py.
