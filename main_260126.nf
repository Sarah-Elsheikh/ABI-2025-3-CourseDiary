// cat file.txt
// \
// | tr -s ' ' '\n'
// \
// | sort
// \
// | uniq -c
// \
// | sort -n
// \
// | tail -1
// \
// | tr -s ' '
// \
// | cut -d ' ' -f
// 3

params.in = null

process normalize_words {
    input:
      path word_file
    
    output:
      path "out.normalized.txt"
    
    script:
    """
    cat "$word_file" \
        | tr -s ' ' '\n'\
        | tr -d '[:punct:]'\
        | tr '[:upper:]' '[:lower:]'\
    > out.normalized.txt
    """
}

process count_words {
    input:
      path word_file
    
    output:
      path "out.counted.txt"
    
    script:
    """
    cat "$word_file" \
        | sort\
        | uniq -c\
        | sort -n\
    > out.counted.txt
    """
}

process take_most_common_word {
    input:
      path word_file

    output:
      path "out.most_common.txt"
    
    script:
    """
    cat "$word_file" \
        | tail -1\
        | tr -s ' '\
        | cut -d ' ' -f 3\
    > out.most_common.txt
    """
}


workflow {
   
    //ch_input = channel.fromPath("/home/sarah/Nextflow/random_text.txt")
    
    ch_input = channel.fromPath(params.in)
    normalize_words(ch_input) | count_words | take_most_common_word
   
    /*
    params.in would allow me to write the path of the folder that has .txt in the prompt instead of hardcoding it

    ch_normalize_words(ch_input) 
    ch_count_words()
    ch_take_most_common_word()
    */
}


// https://github.com/FynnFreyer/nextflow-abi-2025-3
// https://github.com/FynnFreyer/nf-scripts/
// https://www.nf-test.com/

// nextflow run --in "*.txt" main.nf
// tree work/

// groovyconsole
// "" interpolates values (like defined variables).. '' treat it as a text

// can use the #!bin bash line to use multiple languages in the same .nf file