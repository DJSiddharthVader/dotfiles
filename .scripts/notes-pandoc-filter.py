#!/usr/bin/env python
import sys
import json

def makeBlock(tag):
    """ make block for specified raw html tag to insert into block list
        what the AST json element for RawInline html code looks like
        { "t": "RawBlock",
          "c": [
            "html",
            "<details open>"
          ]
        },
        { "t": "Para",
          "c": [
            {
              "t": "RawInline",
              "c": [
                "html",
                "<summary>"
              ]
            }
          ]
        },
    """
    return {"t":"RawBlock","c":["html",tag]}

def getHeaders(blocks,lvl):
    return [i for i,b in enumerate(blocks) if b['t'] == 'Header' and b['c'][0] == lvl]

def makeHeadersCollapsible(blocks,lvl):
    """ want to insert details,summary tags around all headers
        easy for flat headers but need to handle for nested headers

        So for a header insert <details open>, <summary> tags before it
        Then afther the header block (t:"Header") insert </summary> tag
        Then right before the next header block of the same level insert the </details> tag
        This handles the nested headers issue and folding should cover all subheaders of a header

        So code should
        for L in 1..6: #all header lvls
            for all indices i \in I in the block list with header lvl L:
               insert <details open> at Blocks[I[i]-1]
               insert <summary> at Blocks[I[i]-1]
               insert </summary> at Blocks[I[i]+1]
               insert </details> at Blocks[I[i+1]-1]
    """
    header_indices = getHeaders(blocks,lvl) #indices of all h1 blocks
    for i,hi in enumerate(header_indices[::-1]): # go backwards since insert is right shifting
        # get blocks that are only apart of the current h section
        section_start = hi
        if hi == header_indices[-1]:
            section_end = len(blocks)
        else:
            section_end = header_indices[len(header_indices)-i]
        # recurse to next h level looking at only the subsections of the current section
        if len(getHeaders(blocks[section_start:section_end],lvl+1)) != 0:
            blocks[section_start:section_end] = makeHeadersCollapsible(blocks[section_start:section_end],lvl+1)
            header_indices = getHeaders(blocks,lvl) #indices of all h1 blocks
        blocks.insert(hi+1,makeBlock("</summary>")) #after header
        blocks.insert(hi,makeBlock("<summary>")) # before header
        blocks.insert(hi,makeBlock("<details open>")) # 2 before header
        if hi != header_indices[0]: # dont print closer for first header
            blocks.insert(hi,makeBlock("</details>")) #3 before header
    blocks.append(makeBlock("</details>")) # closing for last h1 header
    return blocks

def main(ast_json):
    ast_json['blocks'] = makeHeadersCollapsible(ast_json['blocks'],1)
    return ast_json


if __name__ == "__main__":
    ast_json = json.loads(''.join([line.rstrip()  for line in sys.stdin]))
    print(json.dumps(main(ast_json))) #print modified AST to stdout
