"""PetalOS installer: portable core, Linux adapters, optional GTK overlay."""

__version__ = '0.4.2'


class InstallerError(Exception):
    """Public error text; never include credentials or tool stderr."""
