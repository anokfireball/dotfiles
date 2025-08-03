package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

var pathRegex = regexp.MustCompile(`(?:~/?|\.\.?/?|/)[^\s]*|[^\s]*\.[a-zA-Z0-9]+|[a-zA-Z_][a-zA-Z0-9._/-]*|[a-zA-Z0-9]`)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	seen := make(map[string]bool)
	cwd, _ := os.Getwd()

	for scanner.Scan() {
		matches := pathRegex.FindAllString(scanner.Text(), -1)
		for _, match := range matches {
			if path := processPath(match, cwd, seen); path != "" {
				fmt.Println(path)
			}
		}
	}
}

func processPath(match, cwd string, seen map[string]bool) string {
	clean := cleanPath(match)
	if clean == "" || clean == "." || clean == ".." {
		return ""
	}

	resolved := resolvePath(clean)
	canonical := getCanonicalPath(resolved)

	if seen[canonical] {
		return ""
	}

	stat, err := os.Stat(resolved)
	if err != nil {
		return ""
	}

	seen[canonical] = true
	output := formatOutput(clean, match, resolved, cwd)

	if stat.IsDir() && !strings.HasSuffix(output, "/") {
		output += "/"
	}

	return output
}

func resolvePath(path string) string {
	if strings.HasPrefix(path, "~/") {
		if home, err := os.UserHomeDir(); err == nil {
			return filepath.Join(home, path[2:])
		}
	}
	return path
}

func getCanonicalPath(path string) string {
	if abs, err := filepath.Abs(path); err == nil {
		return abs
	}
	return path
}

func formatOutput(clean, original, resolved, cwd string) string {
	if strings.HasPrefix(clean, "~/") {
		return clean
	}

	if !filepath.IsAbs(original) && !filepath.IsAbs(clean) {
		if rel, err := filepath.Rel(cwd, resolved); err == nil {
			if !strings.HasPrefix(rel, "..") && len(rel) < len(resolved) {
				return rel
			}
		}
	}

	return clean
}

func cleanPath(path string) string {
	if i := strings.Index(path, ":"); i != -1 && isNumeric(path[i+1:]) {
		path = path[:i]
	}
	path = strings.TrimRight(path, ":,.")
	return strings.Trim(path, `"'`)
}

func isNumeric(s string) bool {
	if len(s) == 0 {
		return false
	}
	for _, char := range s {
		if (char < '0' || char > '9') && char != ':' {
			return false
		}
	}
	return true
}
