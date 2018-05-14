#!bin/bash

var=1
tries=0
while [ $var -lt 5 ]; do

   if [ $var -lt 3 ];
       then
           let tries=100000
   elif [ $var -lt 4 ]
       then
           let tries=1000000       # 1 mil
       else
           let tries=10000000      # 10 mil
   fi

   g++ simulation_single.cpp
   ./a.out $var $tries > "./dat/dist/Distribution of ${var}-variable Boolean functions induced by 1 single PUF"

   if [ $var -lt 3 ];
       then
           let tries=100000
   elif [ $var -lt 4 ]
       then
           let tries=1000000       # 1 mil
       else
           let tries=10000000      # 10 mil
   fi

   g++ simulation_xor2.cpp
   ./a.out $var $tries > "./dat/dist/Distribution of ${var}-variable Boolean functions induced by 2 XORed PUFs"

   if [ $var -lt 3 ];
       then
           let tries=100000
   elif [ $var -lt 4 ]
       then
           let tries=1500000       # 1.5 mil
       else
           let tries=2000000000    # 2 bil
   fi

   g++ simulation_xor3.cpp
   ./a.out $var $tries > "./dat/dist/Distribution of ${var}-variable Boolean functions induced by 3 XORed PUFs"

#    if [ $var -lt 3 ];
#        then
#            let tries=100000
#    elif [ $var -lt 4 ]
#        then
#            let tries=1000000       # 1 mil
#        else
#            let tries=4400000000    # 4.4 bil
#    fi

#    g++ simulation_maj.cpp
#    ./a.out $var $tries > "./dat/dist/Distribution of ${var}-variable Boolean functions induced by 3 MAJed PUFs"

   let var=var+1
done

cd ./dat/dist/
for FILE in *; do
    gnuplot <<- EOF
        # Setup
            set terminal png size 1024,600 font ",18"
            set term png font "times_new_roman_bold,18"
            set term png font "/usr/local/fonts/times_new_roman_bold.ttf"

        # Axis / titles
            set xlabel "Function number" font ",18"
            set ylabel"Occurrences" font ",18" offset -2.5,0
            set xrange [-0.5:]
            set yrange [0:]

            set key off
            set grid
            set tics font ",18"
            set rmargin 5
            set lmargin 15

        # Style
            set boxwidth 0.9 relative
            set style fill solid 1.0
            set output "../../figs/dist/" . "${FILE}.png"
            set title "${FILE}"
            plot "${FILE}" with boxes linetype rgb "#1954A6"

       # Stats
            set fit logfile '/dev/null'

            f(x) = mean
            fit f(x) "${FILE}" using 1:2 via mean
            set label "(152 of 256)" at 3.1,152
            set label "(Weekend)" at 1,2700 center
            set label 3 gprintf("Mean = %g", mean) at 1,1
EOF
done

for FILE in *; do
    sort -k2 -n -r "${FILE}" -o "../sorted/${FILE}"
done

cd ../sorted

for FILE in *; do
    awk '{print NR,$0}' "${FILE}" > temp
    mv temp "${FILE}"
done

for FILE in *; do
   tries_done=`awk '{sum+=$3} END{print sum}' "${FILE}"`
   threshold=$(($tries_done * 80/100))                # threshold percentage for coverage
   total=0
   count=1
   while [ $total -lt $threshold ]; do
       line_val=`awk -v line="$count" 'NR==line {print $3}' < "${FILE}"`
       total=$((total + line_val))
       let count=count+1
   done
   let count=count-1
#    echo "90% coverage is given by ${count} functions"
#    echo "The total is: ${total}"

   gnuplot <<- EOF
       # Setup
           set terminal png size 1024,600 font ",18"
           set term png font "times_new_roman_bold,18"
           set term png font "/usr/local/fonts/times_new_roman_bold.ttf"

       # Axis / titles
           set xlabel "Function count" font ",18"
          set ylabel"Occurrences" font ",18" offset -2.5,0
#          set xrange [-0.5:]
          set yrange [0:]

           set key off
           set grid
           set tics font ",18"
          set rmargin 5
           set lmargin 15

       # Stats
           set label "Threshold value for 80% coverage = ${threshold} functions" at screen 0.6, screen 0.9 front
           set label "80% coverage is given by ${count} functions" at screen 0.6, screen 0.85 front

       # Plot
           set boxwidth 0.9 relative
           set style fill solid 1.0
           set output "../../figs/sorted/" . "${FILE}.png"
           set title "${FILE}"
           plot "${FILE}" using 1:3 with boxes linetype rgb "#1954A6"
EOF
done

# lower case dat/sorted/
for FILE in *; do
    mv "${FILE}" "`echo ${FILE} | tr '[A-Z]' '[a-z]'`";
    mv "${FILE}" "${FILE// /_}";
done

cd ../dist/

# lower case dat/dist/
for FILE in *; do
    mv "${FILE}" "`echo ${FILE} | tr '[A-Z]' '[a-z]'`";
    mv "${FILE}" "${FILE// /_}";
done

cd ../../figs/dist/

# lower case figs/dist/
for FILE in *; do
     mv "${FILE}" "`echo ${FILE} | tr '[A-Z]' '[a-z]'`";
     mv "${FILE}" "${FILE// /_}";
done

cd ../sorted/

# lower case figs/sorted/
for FILE in *; do
     mv "${FILE}" "`echo ${FILE} | tr '[A-Z]' '[a-z]'`";
     mv "${FILE}" "${FILE// /_}";
done
