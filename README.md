# SemVer Compare

A bash script for comparing semantic versions with support for greater than, less than, and equal to comparisons.

## Features

- Compares two semantic versions (e.g., 1.2.3, 1.2.3-alpha.1)
- Supports >, <, and == operators
- Handles pre-release versions correctly
- Returns true or false based on the comparison result

## Installation

### Option 1: Direct Download

```bash
sudo curl -L https://raw.githubusercontent.com/fiston/semver-compare/main/semver_compare -o /usr/local/bin/semver-compare
sudo chmod +x /usr/local/bin/semver-compare
```

### Option 2: Clone the Repository

```bash
git clone https://github.com/fiston/semver-compare.git
cd semver-compare
sudo cp semver_compare /usr/local/bin/semver-compare
sudo chmod +x /usr/local/bin/semver-compare
```

### Option 3: Package Manager (if available)

```bash
sudo apt-get update
sudo apt-get install semver-compare
```

## Usage

The basic syntax is:

```bash
semver-compare <version1> <operator> <version2>
```

Where:

- `<version1>` and `<version2>` are semantic versions (e.g., 1.2.3, 1.2.3-alpha.1)
- `<operator>` is one of >, <, or ==

### Examples

```bash
semver-compare 1.2.3 ">" 1.2.2    # Output: true
semver-compare 1.2.3 "<" 1.2.4    # Output: true
semver-compare 1.2.3 "==" 1.2.3   # Output: true
semver-compare 1.2.3-alpha ">" 1.2.3   # Output: false
semver-compare 1.2.3 "<" 1.2.3-beta    # Output: true
```

## In Scripts

You can use the output in your bash scripts like this:

```bash
if [ "$(semver-compare $VERSION ">" 1.2.3)" == "true" ]; then
    echo "Version is greater than 1.2.3"
else
    echo "Version is not greater than 1.2.3"
fi
```

## Limitations

- The script assumes valid semantic version inputs. Invalid inputs may produce unexpected results.
- Build metadata (e.g., 1.2.3+20130313144700) is ignored in comparisons as per SemVer spec.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the [Semantic Versioning 2.0.0](https://semver.org/) specification.
- Thanks to all contributors who have helped to improve this script.

## Support

If you encounter any problems or have any questions, please open an issue on the [GitHub repository](https://github.com/fiston/semver-compare/issues).
