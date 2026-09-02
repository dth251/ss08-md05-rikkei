import sys

def main():
    print("==================================================")
    print("  [QuickBite CI] Docker Build & Run Success!     ")
    print("  Docker-outside-of-Docker (DooD) is functional.  ")
    print("  Python version: " + sys.version.split()[0])
    print("==================================================")

if __name__ == "__main__":
    main()
