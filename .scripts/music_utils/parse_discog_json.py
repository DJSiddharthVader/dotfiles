#!/usr/local/bin/python3
import re
import sys
import json

def getGenre(song):
    try:
        return song['genre'][0]
    except KeyError:
        return ""

def getYear(song):
    try:
        return song['year']
    except KeyError:
        return ""

def getAlbum(song,artist):
    if song:
        album = ' '.join(song['title'].split('-')[1:]).strip(' ')
        if album == "":
            album = '{} - Singles'.format(artist.split('&')[0])
    else:
        album = '{} - Singles'.format(artist.split('&')[0])
    return re.sub("\s+"," ",album)

def standardizeString(string):
    toremove = "\',*!"
    for char in toremove:
        string = string.replace(char,"")
    joiners = "+&"
    for char in joiners:
        string = string.replace(char,'x')
    string = re.sub("[\(\[].*?[\)\]]", "",string)
    return string.lower().strip(' ')

def getSong(results,artist):
    if len(results) != 0:
        index = 0.5 #always invalid
        splitChars ="& x+"
        #artist = set(re.sub(r'[\W ]+','',artist.lower().replace('+','x')).split(' '))
        #artist = artist.lower().strip(' ').replace('+','x').replace('&','x')
        artist = standardizeString(artist)
        raw_artists = [song['title'] for song in results]
        for i,art in enumerate(raw_artists):
            art = standardizeString(art.split('-')[0])
            #art = re.sub("[\(\[].*?[\)\]]", "", art)
            #art = art.lower().strip(' ').replace('&','x').replace('*','')
            if artist.replace(' ','') == art.replace(' ',''):
                index = i
                break
            else:
                for char in splitChars:
                    art_set = set(art.split(char))
                    artist_set = set(artist.split(char))
                    if art_set.issubset(artist_set):
                        index = i
                        break
                    if artist_set.issubset(art_set):
                        index = i
                        break
        try:
            #index = artists.index(artist)
            return results[index]
        #except ValueError: #no match
        except TypeError: #no match
            return "no_results"
    else:
        return "no_results"

def main(json_file,artist,title):
    try:
        discog = json.load(open(json_file))
    except json.decoder.JSONDecodeError:
        album = getAlbum(False,artist)
        year = ""
        genre = ""
        sys.stderr.write("no result\n")
        print("{}__{}__{}__{}__{}".format(title,artist,album,year,genre))
        return None
    song = getSong(discog['results'],artist)
    if song == "no_results":
        album = getAlbum(False,artist)
        year = ""
        genre = ""
        sys.stderr.write("empty result\n")
        print("{}__{}__{}__{}__{}".format(title,artist,album,year,genre))
        return None
    else:
        album = getAlbum(song,artist)
        year = getYear(song)
        genre = getGenre(song)
        sys.stderr.write("worked\n")
        print("{}__{}__{}__{}__{}".format(title,artist,album,year,genre))
        return None


if __name__ == '__main__':
    discog_json = sys.argv[1]
    artist = sys.argv[2]
    title = sys.argv[3]
    main(discog_json,artist,title)
