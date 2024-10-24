import sys
import subprocess
from .main import AutoReq

def main():
    """Main entry point for the pip wrapper"""
    try:
        result = subprocess.run(
            [sys.executable, '-m', 'pip'] + sys.argv[1:],
            capture_output=True,
            text=True
        )
        
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr, file=sys.stderr)
            
        # Only process if pip command succeeds
        if result.returncode == 0:
            auto = AutoReq()
            cmd = sys.argv[1] if len(sys.argv) > 1 else ''
            
            if cmd == 'install':
                for arg in sys.argv[2:]:
                    auto.update_requirements(arg)
            elif cmd == 'uninstall':
                for arg in sys.argv[2:]:
                    auto.update_requirements(arg, remove=True)
                    
        sys.exit(result.returncode)
        
    except subprocess.SubprocessError as e:
        print(f"Pip command failed: {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"File operation failed: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
