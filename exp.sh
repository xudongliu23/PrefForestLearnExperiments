#!/bin/bash

usr_dir=""
if [ "$(hostname)" == 'kestrel' ]; then
  usr_dir=/homes/liu
else
  usr_dir=/home/xudong
fi

root_dir=${usr_dir}/Codes/PrefForestLearnExperiments

CarEvaluation=${root_dir}/CarEvaluation/Scripts/run_fixed_forest_size.sh
total_number_of_issues_CarEvaluation=6
number_of_all_examples_CarEvaluation=682721
training_size_CarEvaluation=$((7*$number_of_all_examples_CarEvaluation/10))

TicTacToe=${root_dir}/TicTacToe/Scripts/run_fixed_forest_size.sh
total_number_of_issues_TicTacToe=9
number_of_all_examples_TicTacToe=207832
training_size_TicTacToe=$((7*$number_of_all_examples_TicTacToe/10))

NurseryDownsampledFurther=${root_dir}/NurseryDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_NurseryDownsampledFurther=8
number_of_all_examples_NurseryDownsampledFurther=548064
training_size_NurseryDownsampledFurther=$((7*$number_of_all_examples_NurseryDownsampledFurther/10))

MammographicMassDownsampled=${root_dir}/MammographicMassDownsampled/Scripts/run_fixed_forest_size.sh
total_number_of_issues_MammographicMassDownsampled=5
number_of_all_examples_MammographicMassDownsampled=792
training_size_MammographicMassDownsampled=$((7*$number_of_all_examples_MammographicMassDownsampled/10))

MushroomDownsampled=${root_dir}/MammographicMassDownsampled/Scripts/run_fixed_forest_size.sh
total_number_of_issues_MushroomDownsampled=10
number_of_all_examples_MushroomDownsampled=8448
training_size_MushroomDownsampled=$((7*$number_of_all_examples_MushroomDownsampled/10))

WineDownsampled=${root_dir}/WineDownsampled/Scripts/run_fixed_forest_size.sh
total_number_of_issues_WineDownsampled=10
number_of_all_examples_WineDownsampled=10322
training_size_WineDownsampled=$((7*$number_of_all_examples_WineDownsampled/10))

#Cars1=${root_dir}/Cars1/Scripts/run_fixed_forest_size.sh
#Cars2=${root_dir}/Cars2/Scripts/run_fixed_forest_size.sh

BreastCancerWisconsinDownsampled=${root_dir}/BreastCancerWisconsinDownsampled/Scripts/run_fixed_forest_size.sh
total_number_of_issues_BreastCancerWisconsinDownsampled=9
number_of_all_examples_BreastCancerWisconsinDownsampled=9009
training_size_BreastCancerWisconsinDownsampled=$((7*$number_of_all_examples_BreastCancerWisconsinDownsampled/10))

IonosphereDownsampledFurther=${root_dir}/IonosphereDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_IonosphereDownsampledFurther=10
number_of_all_examples_IonosphereDownsampledFurther=3472
training_size_IonosphereDownsampledFurther=$((7*$number_of_all_examples_IonosphereDownsampledFurther/10))

SpectHeartDownsampledFurther=${root_dir}/SpectHeartDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_SpectHeartDownsampledFurther=10
number_of_all_examples_SpectHeartDownsampledFurther=3196
training_size_SpectHeartDownsampledFurther=$((7*$number_of_all_examples_SpectHeartDownsampledFurther/10))

CreditApprovalDownsampledFurther=${root_dir}/CreditApprovalDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_CreditApprovalDownsampledFurther=10
number_of_all_examples_CreditApprovalDownsampledFurther=66079
training_size_CreditApprovalDownsampledFurther=$((7*$number_of_all_examples_CreditApprovalDownsampledFurther/10))

GermanCreditDownsampledFurther=${root_dir}/CreditApprovalDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_GermanCreditDownsampledFurther=10
number_of_all_examples_GermanCreditDownsampledFurther=172368
training_size_GermanCreditDownsampledFurther=$((7*$number_of_all_examples_GermanCreditDownsampledFurther/10))

VehicleDownsampledFurther=${root_dir}/VehicleDownsampledFurther/Scripts/run_fixed_forest_size.sh
total_number_of_issues_VehicleDownsampledFurther=10
number_of_all_examples_VehicleDownsampledFurther=76713
training_size_VehicleDownsampledFurther=$((7*$number_of_all_examples_VehicleDownsampledFurther/10))

clingo3=${usr_dir}/.tools/clingo-3.0.5/clingo-3.0.5
gringo3=${usr_dir}/.tools/gringo-3.0.5/gringo-3.0.5
clasp=${usr_dir}/.tools/clasp-3.1.3/clasp-3.1.3
number_of_iterations=1
num_train_strict_examples_per_tree=50
size_of_forest=6000

time $CarEvaluation CarEvaluation $gringo3 $clasp $usr_dir $training_size_CarEvaluation \
	$number_of_all_examples_CarEvaluation $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_CarEvaluation

time $NurseryDownsampledFurther NurseryDownsampledFurther $gringo3 $clasp $usr_dir $training_size_NurseryDownsampledFurther \
	$number_of_all_examples_NurseryDownsampledFurther $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_NurseryDownsampledFurther

#time $TicTacToe TicTacToe $gringo3 $clasp $usr_dir $training_size_TicTacToe \
#	$number_of_all_examples_TicTacToe $num_train_strict_examples_per_tree \
#	$size_of_forest $number_of_iterations $total_number_of_issues_TicTacToe

time $VehicleDownsampledFurther VehicleDownsampledFurther $gringo3 $clasp $usr_dir $training_size_VehicleDownsampledFurther \
	$number_of_all_examples_VehicleDownsampledFurther $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_VehicleDownsampledFurther

# TOO SLOW!
#time $GermanCreditDownsampledFurther GermanCreditDownsampledFurther $gringo3 $clasp $usr_dir $training_size_GermanCreditDownsampledFurther \
#	$number_of_all_examples_GermanCreditDownsampledFurther $num_train_strict_examples_per_tree \
#	$size_of_forest $number_of_iterations $total_number_of_issues_GermanCreditDownsampledFurther

time $CreditApprovalDownsampledFurther CreditApprovalDownsampledFurther $gringo3 $clasp $usr_dir $training_size_CreditApprovalDownsampledFurther \
	$number_of_all_examples_CreditApprovalDownsampledFurther $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_CreditApprovalDownsampledFurther

time $SpectHeartDownsampledFurther SpectHeartDownsampledFurther $gringo3 $clasp $usr_dir $training_size_SpectHeartDownsampledFurther \
	$number_of_all_examples_SpectHeartDownsampledFurther $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_SpectHeartDownsampledFurther

time $IonosphereDownsampledFurther IonosphereDownsampledFurther $gringo3 $clasp $usr_dir $training_size_IonosphereDownsampledFurther \
	$number_of_all_examples_IonosphereDownsampledFurther $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_IonosphereDownsampledFurther

time $BreastCancerWisconsinDownsampled BreastCancerWisconsinDownsampled $gringo3 $clasp $usr_dir $training_size_BreastCancerWisconsinDownsampled \
	$number_of_all_examples_BreastCancerWisconsinDownsampled $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_BreastCancerWisconsinDownsampled

time $WineDownsampled WineDownsampled $gringo3 $clasp $usr_dir $training_size_WineDownsampled \
	$number_of_all_examples_WineDownsampled $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_WineDownsampled

# TOO SLOW!
#time $MushroomDownsampled MushroomDownsampled $gringo3 $clasp $usr_dir $training_size_MushroomDownsampled \
#	$number_of_all_examples_MushroomDownsampled $num_train_strict_examples_per_tree \
#	$size_of_forest $number_of_iterations $total_number_of_issues_MushroomDownsampled

time $MammographicMassDownsampled MammographicMassDownsampled $gringo3 $clasp $usr_dir $training_size_MammographicMassDownsampled \
	$number_of_all_examples_MammographicMassDownsampled $num_train_strict_examples_per_tree \
	$size_of_forest $number_of_iterations $total_number_of_issues_MammographicMassDownsampled
