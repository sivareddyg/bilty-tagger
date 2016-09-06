import sys

index = 1
for line in sys.stdin:
	parts = line.strip().split("\t")
	if len(parts) < 3:
		print()
		index = 1
		continue
	conll = []
	conll.append("%d" %index)
	conll.append(parts[0])
	conll.append("_")
	conll.append(parts[2])
	conll.append(parts[2])
	conll.append("_")
	conll.append("0")
	conll.append("root")
	conll.append("_")
	conll.append("_")
	print ("\t".join(conll))	
	index += 1
