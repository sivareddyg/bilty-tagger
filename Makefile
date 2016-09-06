create_data_%:
	cut -f2,4 ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-dev.conllx | python scripts/make_lower.py > $*-ud-dev.tags
	cut -f2,4 ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-train.conllx  | python scripts/make_lower.py > $*-ud-train.tags
	cut -f2,4 ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-test.conllx  | python scripts/make_lower.py > $*-ud-test.tags

train_%:	
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500 --train $*-ud-train.tags --test $*-ud-test.tags --dev $*-ud-dev.tags --output predictions/bilty/$*-ud-test.conllu.bilty-$*-ud1.3-poly-i20-h1 --in_dim 64 --c_in_dim 100 --trainer sgd --iters 20 --sigma 0.2 --save models/bilty/bilty-$*-ud1.3-poly-i20-h1.model --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1  > nohup/bilty-$*-ud1.3-poly-i20-h1.out

test_%:
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model --test $*-ud-test.tags  --output $*-ud-test.conllu.bilty-$*-ud1.3-poly-i20-h1 --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 > bilty-$*-ud1.3-poly-i20-h1.out


tag_ud-%:
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model --test $*-ud-train.tags  --output $*-ud-train.conllu.bilty-$*-ud1.3-poly-i20-h1 --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 > bilty-$*-ud1.3-poly-i20-h1.out
	python scripts/convert_to_conllx.py \
		< $*-ud-train.conllu.bilty-$*-ud1.3-poly-i20-h1.task0 \
		| python scripts/merge_with_gold_conll.py ../bist-parser/barchybrid/ud-treebanks-v1.3/UD_$*/$*-ud-train.conllx \
		> ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-train.bilty.conllx
	
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model --test $*-ud-dev.tags  --output $*-ud-dev.conllu.bilty-$*-ud1.3-poly-i20-h1 --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 > bilty-$*-ud1.3-poly-i20-h1.out
	python scripts/convert_to_conllx.py \
		< $*-ud-dev.conllu.bilty-$*-ud1.3-poly-i20-h1.task0 \
		| python scripts/merge_with_gold_conll.py ../bist-parser/barchybrid/ud-treebanks-v1.3/UD_$*/$*-ud-dev.conllx \
		> ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-dev.bilty.conllx
	
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model --test $*-ud-test.tags  --output $*-ud-test.conllu.bilty-$*-ud1.3-poly-i20-h1 --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 > bilty-$*-ud1.3-poly-i20-h1.out
	python scripts/convert_to_conllx.py \
		< $*-ud-test.conllu.bilty-$*-ud1.3-poly-i20-h1.task0 \
		| python scripts/merge_with_gold_conll.py ../bist-parser/barchybrid/ud-treebanks-v1.3/UD_$*/$*-ud-test.conllx \
		> ../lstm-parser/ud-treebanks-v1.3/UD_$*/$*-ud-test.bilty.conllx

tag_webquestions_%:
	cut -f2,4 webquestions/$*-webquestions.dev.forest.conll \
		| python scripts/make_lower.py \
		> webquestions/$*-webquestions.dev.forest.tags
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  \
		--model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model \
		--test webquestions/$*-webquestions.dev.forest.tags \
		--output webquestions/$*-webquestions.dev.forest.tags.out \
		--embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 \
		> /dev/null
	python scripts/convert_to_conllx.py \
		< webquestions/$*-webquestions.dev.forest.tags.out.task0 \
		> webquestions/$*-bilty-webquestions.dev.forest.tagged.conll 
	rm webquestions/$*-webquestions.dev.forest.tags.out.task0

	cut -f2,4 webquestions/$*-webquestions.train.forest.conll \
                | python scripts/make_lower.py \
                > webquestions/$*-webquestions.train.forest.tags
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  \
                --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model \
                --test webquestions/$*-webquestions.train.forest.tags \
                --output webquestions/$*-webquestions.train.forest.tags.out \
                --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 \
                > /dev/null
	python scripts/convert_to_conllx.py \
                < webquestions/$*-webquestions.train.forest.tags.out.task0 \
                > webquestions/$*-bilty-webquestions.train.forest.tagged.conll
	rm webquestions/$*-webquestions.train.forest.tags.out.task0

	cut -f2,4 webquestions/$*-webquestions.test.forest.conll \
                | python scripts/make_lower.py \
                > webquestions/$*-webquestions.test.forest.tags
	python src/bilty.py --cnn-seed 1512141834 --cnn-mem 1500  \
                --model models/bilty/bilty-$*-ud1.3-poly-i20-h1.model.model \
                --test webquestions/$*-webquestions.test.forest.tags \
                --output webquestions/$*-webquestions.test.forest.tags.out \
                --embeds embeds/poly_a/$*.polyglot.txt --h_layers 1 --pred_layer 1 \
                > /dev/null
	python scripts/convert_to_conllx.py \
                < webquestions/$*-webquestions.test.forest.tags.out.task0 \
                > webquestions/$*-bilty-webquestions.test.forest.tagged.conll
	rm webquestions/$*-webquestions.test.forest.tags.out.task0

