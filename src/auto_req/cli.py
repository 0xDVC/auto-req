import sys
import subprocess
from .main import AutoReq
import site
from pathlib import Path


def is_externally_managed() -> bool:
    """Check if Python environment is externally managed (Python 3.12+)."""
    major, minor = sys.version_info[:2]

    # Only Python 3.12+ has this feature
    if (major, minor) >= (3, 12):
        try:
            
            site_packages = Path(site.getsitepackages()[0])
            user_site = Path(site.getusersitepackages()) if site.ENABLE_USER_SITE else None
            
            # Look for EXTERNALLY-MANAGED in either location
            has_external = (site_packages / "EXTERNALLY-MANAGED").exists()
            if user_site:
                has_external = has_external or (user_site / "EXTERNALLY-MANAGED").exists()
                
            return has_external
            
        except Exception as e:
            print(f"Warning: Could not check for external management: {e}", file=sys.stderr)
            return False

def main():
    """Execute pip commands and automatically update requirements.txt.
    
    Handles install/uninstall commands while managing external environment flags.
    Exits with pip's return code or 1 on error.
    """

    try:
        external = is_externally_managed()
        if external:
            print("Warning: Operating in an externally managed environment", file=sys.stderr)

        # capture_output = sys.argv[1] != "uninstall" if len(sys.argv) > 1 else True
        
        # Add --break-system-packages only if needed (for external environments)
        pip_args = sys.argv[1:]
        if external:
            pip_args.append("--break-system-packages")
        
        result = subprocess.run(
            [sys.executable, '-m', 'pip'] + pip_args,
            # capture_output=capture_output,
            text=True
        )
        
        # if capture_output:
        #     if result.stdout:
        #         print(result.stdout)
        #     if result.stderr:
        #         print(result.stderr, file=sys.stderr)
            
        if result.returncode == 0:
            auto = AutoReq()

            cmd = sys.argv[1] if len(sys.argv) > 1 else ''

            if cmd == 'install' and 'auto-req' in sys.argv[2:]:
                auto.post_install()
                return
            
            if cmd == 'install':
                for arg in sys.argv[2:]:
                    if not arg.startswith('-'):
                        auto.update_requirements(arg)
            elif cmd == 'uninstall':
                for arg in sys.argv[2:]:
                    if not arg.startswith('-'):
                        auto.update_requirements(arg, remove=True)
            
            if not auto.req_file.exists():
                print("Warning: requirements.txt was not created!", file=sys.stderr)

        sys.exit(result.returncode)
        
    except subprocess.SubprocessError as e:
        print(f"Pip command failed: {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"File operation failed: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error in auto-req: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
