accessions = 's3://pipe-out/resources/accessions.txt'

process pullNCBI {

    input:
    val x

    output:
    path "${x}.lower"

    """
    datasets summary genome accession $x > ${x}.lower
    """
}

process convertToUpper {
	publishDir './work/', mode: 'move'

    input:
    path x

    output:
    file("${x.baseName}.upper")

    """
    cat $x | tr '[a-z]' '[A-Z]' > ${x.baseName}.upper
    """
}

workflow {
    Channel.of(file(accessions).readLines()) | flatten | splitLetters | convertToUpper 
}
