import sys

f = open(sys.argv[1])
for line in sys.stdin:
	gold = f.readline().strip().split("\t")
	pred = line.strip().split("\t")
	if len(gold) != len(pred):
		sys.stderr.write("Sentences are not alingned")
		exit()
	if len(pred) < 2:
		print()
		continue
	pred[6:9] = gold[6:9]
	print("\t".join(pred))
f.close()
