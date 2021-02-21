#!/bin/bash

#Codon Table
#[AAA] Lys K   Lysine
#[AAC] Asn N   Asparagine
#[AAG] Lys K   Lysine
#[AAT] Asn N   Asparagine
#[ACA] Thr T   Threonine
#[ACC] Thr T   Threonine
#[ACG] Thr T   Threonine
#[ACT] Thr T   Threonine
#[AGA] Arg R   Arginine
#[AGC] Ser S   Serine
#[AGG] Arg R   Arginine
#[AGT] Ser S   Serine
#[ATA] Ile I   Isoleucine
#[ATC] Ile I   Isoleucine
#[ATG] Met M   Methionine
#[ATT] Ile I   Isoleucine
#[CAA] Gln Q   Glutamine
#[CAC] His H   Histidine
#[CAG] Gln Q   Glutamine
#[CAT] His H   Histidine
#[CCA] Pro P   Proline
#[CCC] Pro P   Proline
#[CCG] Pro P   Proline
#[CCT] Pro P   Proline
#[CGA] Arg R   Arginine
#[CGC] Arg R   Arginine
#[CGG] Arg R   Arginine
#[CGT] Arg R   Arginine
#[CTA] Leu L   Leucine
#[CTC] Leu L   Leucine
#[CTG] Leu L   Leucine
#[CTT] Leu L   Leucine
#[GAA] Glu E   Glutamic_acid
#[GAC] Asp D   Aspartic_acid
#[GAG] Glu E   Glutamic_acid
#[GAT] Asp D   Aspartic_acid
#[GCA] Ala A   Alanine
#[GCC] Ala A   Alanine
#[GCG] Ala A   Alanine
#[GCT] Ala A   Alanine
#[GGA] Gly G   Glycine
#[GGC] Gly G   Glycine
#[GGG] Gly G   Glycine
#[GGT] Gly G   Glycine
#[GTA] Val V   Valine
#[GTC] Val V   Valine
#[GTG] Val V   Valine
#[GTT] Val V   Valine
#[TAA] Stp O   Stop
#[TAC] Tyr Y   Tyrosine
#[TAG] Stp O   Stop
#[TAT] Tyr Y   Tyrosine
#[TCA] Ser S   Serine
#[TCC] Ser S   Serine
#[TCG] Ser S   Serine
#[TCT] Ser S   Serine
#[TGA] Stp O   Stop
#[TGC] Cys C   Cysteine
#[TGG] Trp W   Tryptophan
#[TGT] Cys C   Cysteine
#[TTA] Leu L   Leucine
#[TTC] Phe F   Phenylalanine
#[TTG] Leu L   Leucine
#[TTT] Phe F   Phenylalanine

#Codon table dictionaries
declare -A codon_table=( [AAA]=K [AAC]=N [AAG]=K [AAT]=N [ACA]=T [ACC]=T [ACG]=T [ACT]=T [AGA]=R [AGC]=S [AGG]=R [AGT]=S [ATA]=I [ATC]=I [ATG]=M [ATT]=I [CAA]=Q [CAC]=H [CAG]=Q [CAT]=H [CCA]=P [CCC]=P [CCG]=P [CCT]=P [CGA]=R [CGC]=R [CGG]=R [CGT]=R [CTA]=L [CTC]=L [CTG]=L [CTT]=L [GAA]=E [GAC]=D [GAG]=E [GAT]=D [GCA]=A [GCC]=A [GCG]=A [GCT]=A [GGA]=G [GGC]=G [GGG]=G [GGT]=G [GTA]=V [GTC]=V [GTG]=V [GTT]=V [TAA]=O [TAC]=Y [TAG]=O [TAT]=Y [TCA]=S [TCC]=S [TCG]=S [TCT]=S [TGA]=O [TGC]=C [TGG]=W [TGT]=C [TTA]=L [TTC]=F [TTG]=L [TTT]=F)
declare -A codon_table_long=( [AAA]=Lys [AAC]=Asn [AAG]=Lys [AAT]=Asn [ACA]=Thr [ACC]=Thr [ACG]=Thr [ACT]=Thr [AGA]=Arg [AGC]=Ser [AGG]=Arg [AGT]=Ser [ATA]=Ile [ATC]=Ile [ATG]=Met [ATT]=Ile [CAA]=Gln [CAC]=His [CAG]=Gln [CAT]=His [CCA]=Pro [CCC]=Pro [CCG]=Pro [CCT]=Pro [CGA]=Arg [CGC]=Arg [CGG]=Arg [CGT]=Arg [CTA]=Leu [CTC]=Leu [CTG]=Leu [CTT]=Leu [GAA]=Glu [GAC]=Asp [GAG]=Glu [GAT]=Asp [GCA]=Ala [GCC]=Ala [GCG]=Ala [GCT]=Ala [GGA]=Gly [GGC]=Gly [GGG]=Gly [GGT]=Gly [GTA]=Val [GTC]=Val [GTG]=Val [GTT]=Val [TAA]=Stp [TAC]=Tyr [TAG]=Stp [TAT]=Tyr [TCA]=Ser [TCC]=Ser [TCG]=Ser [TCT]=Ser [TGA]=Stp [TGC]=Cys [TGG]=Trp [TGT]=Cys [TTA]=Leu [TTC]=Phe [TTG]=Leu [TTT]=Phe )
declare -A codon_table_full=( [AAA]=Lysine [AAC]=Asparagine [AAG]=Lysine [AAT]=Asparagine [ACA]=Threonine [ACC]=Threonine [ACG]=Threonine [ACT]=Threonine [AGA]=Arginine [AGC]=Serine [AGG]=Arginine [AGT]=Serine [ATA]=Isoleucine [ATC]=Isoleucine [ATG]=Methionine [ATT]=Isoleucine [CAA]=Glutamine [CAC]=Histidine [CAG]=Glutamine [CAT]=Histidine [CCA]=Proline [CCC]=Proline [CCG]=Proline [CCT]=Proline [CGA]=Arginine [CGC]=Arginine [CGG]=Arginine [CGT]=Arginine [CTA]=Leucine [CTC]=Leucine [CTG]=Leucine [CTT]=Leucine [GAA]=Glutamic_acid [GAC]=Aspartic_acid [GAG]=Glutamic_acid [GAT]=Aspartic_acid [GCA]=Alanine [GCC]=Alanine [GCG]=Alanine [GCT]=Alanine [GGA]=Glycine [GGC]=Glycine [GGG]=Glycine [GGT]=Glycine [GTA]=Valine [GTC]=Valine [GTG]=Valine [GTT]=Valine [TAA]=Stop [TAC]=Tyrosine [TAG]=Stop [TAT]=Tyrosine [TCA]=Serine [TCC]=Serine [TCG]=Serine [TCT]=Serine [TGA]=Stop [TGC]=Cysteine [TGG]=Tryptophan [TGT]=Cysteine [TTA]=Leucine [TTC]=Phenylalanine [TTG]=Leucine [TTT]=Phenylalanine )


function translate(){
    seq="$(echo $1 | sed -e 's/[uU]/T/g')"
    style="$2" #1 letter, 3 letter, full
    frame="$3" #frame 0,1,2? only open frame
    spacer='-'
    translated=""
    for (( i=$frame; i<${#seq}; i++ )); do
        idx=$(( $i + 3 ))
        codon="${seq:$idx:3}"
        case $style in
            l1) new_codon="$codon_table[$codon]" ;;
            l3) new_codon="$codon_table_long[$codon]" ;;
            full) new_codon="$codon_table_full[$codon]" ;;
            *) echo "Invalid arg use {l1|l3|full}" && exit 1 ;;
        esac
        translated="$translated$spacer$new_codon"
    done
    echo "$translated" | sed -e "s/^$spacer/N' /" | sed -e "s/$/ C'/"
}
function match_primer(){
    #find index where a primer starts in its sequence or rev-comp
    #print complement sequence after primer
    primer="$1"
    target="$2"
}
function generate() {
    #generate random sequence
    length="$1"
}
function complement(){
    seq="$1"
    mode="$2" #output type
    complement="$(echo "$seq" | sed -e 's/[aA]/Z/g'   \
                                    -e 's/[tTuU]/A/g' \
                                    -e 's/Z/T/g'      \
                                    -e 's/[cC]/Z/g'   \
                                    -e 's/[gG]/C/g'   \
                                    -e 's/Z/G/g')"
    case "$mode" in
        'rna') echo "$complement" | sed -s 's/T/U/g' ;;
        'dna') echo "$complement" ;;
        *) echo 'Invalid mode, use {dna|rna}' &&  exit 1 ;;
    esac
}
function reverse(){
    seq="$1"
    echo "$seq" | rev
}
function rev_comp(){
    seq="$1"
    mode="$2"
    complement "$seq" "$mode" | rev
}
function main(){
    exit 1
}
main "$@"
