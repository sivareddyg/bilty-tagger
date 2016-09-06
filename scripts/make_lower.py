import sys
for line in sys.stdin:
	parts = line.strip().split("\t")
	if parts != []:
		parts[0] = parts[0].lower()
	print("\t".join(parts))
