#!/bin/bash

## MaxLearn, UIUP PLP-forests, TicTacToe Dataset, 1 user, with 207832 examples over 958 outcomes.

dataset_name=$1
#clingo=$2
gringo=$2
clasp=$3
usr_dir=$4
training_sample_size=$5
number_of_all_examples=$6
training_sample_size_per_tree=$7
size_of_forest=$8
number_of_iterations=$9
total_number_of_issues=${10}
number_of_users=1
root_dir=${usr_dir}/Codes/PrefForestLearnExperiments/${dataset_name}
origin_dir=${root_dir}/Original
transformed_dir=${root_dir}/Transformed
ASP_dir=${root_dir}/ASP
Scripts_dir=${root_dir}/Scripts
pair_prefs=preferences1.csv
examples_ASP=examples.gringo
number_of_strict_ex_ASP=number_of_strict_examples.gringo
rules_train_ASP=rules_train.gringo
rules_test_ASP=rules_test.gringo
rules_test_ASP_template=rules_test_template.gringo

data=${ASP_dir}/data.gringo
outcomes=${ASP_dir}/outcomes.gringo
#rules=${ASP_dir}/rules.gringo
train_pars="-c tn=$total_number_of_issues -c mn=$total_number_of_issues"
test_pars="-c tn=$total_number_of_issues"
time_pars="--time-limit=0"

results_dir=${root_dir}/Results
parser_hr=${root_dir}/C++Src/parser

## preprocess the original Car dataset 1 and create examples in ASP
function preRun {
	${Scripts_dir}/create_datasets.sh $number_of_users $number_of_iterations $root_dir $origin_dir $training_sample_size
	${Scripts_dir}/preprocess_data.sh $number_of_users $number_of_iterations $origin_dir $transformed_dir $pair_prefs $parser_hr $ASP_dir
	${Scripts_dir}/make_ASP.sh $number_of_users $number_of_iterations $transformed_dir $ASP_dir $pair_prefs $examples_ASP $number_of_strict_ex_ASP
}

## run the experiments
function run {
	for (( i=0; i<$number_of_users; i+=1 )); do
    mkdir -p ${results_dir}/User${i}/${size_of_forest}trees/Training
    mkdir -p ${results_dir}/User${i}/${size_of_forest}trees/Testing
		for (( j=0; j<$number_of_iterations; j+=1 )); do
			# Train size_of_forest trees first
			trainForest $i $j

			# Randomly pick k trees to form a forest for training and testing results
			#for (( k=50; k<=50; k+=1 )); do
			#	rand-UIUP-forest $i $j $k
			#done
		done
	done
}

## Randomly pick k trees to form a forest for training and testing results
function rand-UIUP-forest {
	mkdir -p ${results_dir}/User$1/$3trees/Training
	mkdir -p ${results_dir}/User$1/$3trees/Testing
	for (( l=0; l<10; l+=1 )); do  # Repeat 10 times for each k
		cat /dev/null > ${results_dir}/User$1/$3trees/Training/trees${l}.gringo
		for m in $(seq $size_of_forest | shuf | head -n $k); do
			sed -n "$m,$m p" ${results_dir}/User$1/${size_of_forest}trees/Training/trees_res0.gringo >> \
				${results_dir}/User$1/$3trees/Training/trees_res${l}.gringo
		done
		I=0
		less ${results_dir}/User$1/$3trees/Training/trees_res${l}.gringo | while read -r line ; do
		  changedLine=${line//(/($I,}
		  line=${changedLine//)/).}
		  echo $line >> ${results_dir}/User$1/$3trees/Training/trees${l}.gringo
		  I=$((I+1))
		done
		rm ${results_dir}/User$1/$3trees/Training/trees_res${l}.gringo

		# Test the learned forest on the training set (sort of like testing already)
		$gringo $test_pars $data ${ASP_dir}/User$1/Training/examples$2.gringo \
			${ASP_dir}/User$1/Training/number_of_strict_examples$2.gringo \
			$outcomes ${ASP_dir}/$rules_test_ASP ${results_dir}/User$1/$3trees/Training/trees${l}.gringo | \
			$clasp $time_pars > \
			${results_dir}/User$1/$3trees/Training/res${l}.txt 2>&1
		
		# Testing
		$gringo $test_pars $data ${ASP_dir}/User$1/Testing/examples$2.gringo \
			${ASP_dir}/User$1/Testing/number_of_strict_examples$2.gringo \
			$outcomes ${ASP_dir}/$rules_test_ASP ${results_dir}/User$1/$3trees/Training/trees${l}.gringo | \
			$clasp $time_pars > \
			${results_dir}/User$1/$3trees/Testing/res${l}.txt 2>&1
	done
}

## Train a UIUP-forest
function trainForest {
	mkdir -p ${ASP_dir}/User$1/Training/tmp/
	mkdir -p ${results_dir}/User$1/${size_of_forest}trees/Training/tmp
  cat /dev/null > ${results_dir}/User$1/${size_of_forest}trees/Training/trees_res$2.gringo
  cat /dev/null > ${results_dir}/User$1/${size_of_forest}trees/Training/trees$2.gringo
	for ((k=0; k<$size_of_forest; k+=1)); do
		# Randomly select $training_sample_size_per_tree examples and train a UIUP tree
		shuf -n $training_sample_size_per_tree ${ASP_dir}/User$1/Training/examples$2.gringo > \
			${ASP_dir}/User$1/Training/tmp/examples_for_tree${k}.gringo
		echo "numberOfStrict(${training_sample_size_per_tree})." > \
			${ASP_dir}/User$1/Training/tmp/number_of_strict_examples_for_tree${k}.gringo
		
		$gringo ${ASP_dir}/User$1/Training/tmp/examples_for_tree${k}.gringo $data \
			${ASP_dir}/User$1/Training/tmp/number_of_strict_examples_for_tree${k}.gringo \
			$outcomes ${ASP_dir}/$rules_train_ASP $train_pars | $clasp $time_pars > \
			${results_dir}/User$1/${size_of_forest}trees/Training/tmp/res_for_tree${k}.txt 2>&1

		# Get the learned tree
		TREE_LEARNED="$(grep -B 2 OPTIMUM ${results_dir}/User${i}/${size_of_forest}trees/Training/tmp/res_for_tree${k}.txt | sed -n 1p)"
		echo "${TREE_LEARNED}" >> ${results_dir}/User$1/${size_of_forest}trees/Training/trees_res$2.gringo
	done
	rm -rf ${ASP_dir}/User$1/Training/tmp/
	rm -rf ${results_dir}/User$1/${size_of_forest}trees/Training/tmp
}

## get the learned UIUP trees
function postRun {
  cat /dev/null > ${results_dir}/results${size_of_forest}.txt
  for (( i=0; i<$number_of_users; i+=1 )); do
    echo "MaxLearn UIUP PLP-forests for user $i:" >> ${results_dir}/results${size_of_forest}.txt
    echo "" >> ${results_dir}/results${size_of_forest}.txt
    echo "" >> ${results_dir}/results${size_of_forest}.txt
    for (( j=0; j<$number_of_iterations; j+=1 )); do
				# for training, get the numbers
        echo "Using training data number $j:" >> ${results_dir}/results${size_of_forest}.txt
        NUM_OF_SAT_PREDICATE="$(grep -B 1 SATISFIABLE ${results_dir}/User${i}/${size_of_forest}trees/Training/res${j}.txt | sed -n 1p)"
        NUM_OF_SAT="$(echo $NUM_OF_SAT_PREDICATE | cut -d "(" -f2 | cut -d ")" -f1)"
        RESULT=$(awk "BEGIN {printf \"%.6f\",${NUM_OF_SAT}/${training_sample_size}}")
        echo "Satisfy ${NUM_OF_SAT} out of ${training_sample_size} (${RESULT}) examples." >> \
					${results_dir}/results${size_of_forest}.txt
        echo "" >> ${results_dir}/results${size_of_forest}.txt

        # for testing, get the numbers
        echo "Using testing data number $j:" >> ${results_dir}/results${size_of_forest}.txt
        NUM_OF_SAT_PREDICATE="$(grep -B 1 SATISFIABLE ${results_dir}/User${i}/${size_of_forest}trees/Testing/res${j}.txt | sed -n 1p)"
        NUM_OF_SAT="$(echo $NUM_OF_SAT_PREDICATE | cut -d "(" -f2 | cut -d ")" -f1)"
        NUM_OF_EXTRA=$((number_of_all_examples-training_sample_size))
        RESULT=$(awk "BEGIN {printf \"%.6f\",${NUM_OF_SAT}/${NUM_OF_EXTRA}}")
        echo "Satisfy ${NUM_OF_SAT} out of ${NUM_OF_EXTRA} (${RESULT}) examples." >> \
					${results_dir}/results${size_of_forest}.txt
        echo "" >> ${results_dir}/results${size_of_forest}.txt
        echo "" >> ${results_dir}/results${size_of_forest}.txt
    done
  done

	# compute average accuracy
	#echo "Avarage accuracy: " >> ${results_dir}/results.txt
	#grep -Eo '\([0-9]+\.?[0-9]*\)' ${results_dir}/results.txt | sed 's/.$//; s/^.//' | awk '{a+=$1} END{print a/NR}' \
	#	>> ${results_dir}/results.txt
}

## clean up the intermedia data, that is, all the directory for the Users
function cleanup {
	rm -rf ${origin_dir}/StrictExamples
	for (( i=0; i<$number_of_users; i+=1 )); do
		rm -rf ${ASP_dir}/User${i} ${results_dir}/User${i} ${transformed_dir}/User${i}
	done
	rm -rf ${transformed_dir}
}

## main function
function main {
	preRun
	run
	#postRun
	#cleanup
}

########## main
main
