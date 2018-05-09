#!bin/bash

var=1
while [ $var -lt 5 ]; do

    g++ simulation_single.cpp
    ./a.out $var > "./dat/Distribution of ${var}-variable Boolean functions induced by a single PUF"

    g++ simulation_xor2.cpp
    ./a.out $var > "./dat/Distribution of ${var}-variable Boolean functions induced by two XORed PUFs"

    g++ simulation_xor3.cpp
    ./a.out $var > "./dat/Distribution of ${var}-variable Boolean functions induced by three XORed PUFs"

#    g++ simulation_maj.cpp
#    ./a.out $var > "./dat/Distribution of ${var}-variable Boolean functions induced by three MAJed PUFs"

    let var=var+1
done

cd ./dat/
for FILE in *; do
    gnuplot <<- EOF
        # Setup
            set terminal png size 1024,768 font ",18"
            set term png font "times_new_roman_bold,18"
            set term png font "/usr/local/fonts/times_new_roman_bold.ttf"

        # Axis / titles
            set xlabel "Function number" font ",18"
    	    set ylabel"Occurrences" font ",18" offset 0.5,0
    	    set xrange [-0.5:]
    	    set yrange [0:]

            set key off
            set grid
            set tics font ",18"
    	    set rmargin 5

        # Style
            set boxwidth 0.9 relative
            set style fill solid 1.0
            set output "../figs/" . "${FILE}.png"
            set title "${FILE}"
            plot "${FILE}" with boxes linetype rgb "#1954A6"
EOF
done

#rm ../figs/functions.png
#rm ../figs/functions_log.png