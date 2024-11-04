import groovy.transform.Field

@Field PATH = []
@Field FILE = []
@Field COMMENT = []
@Field TITLE = []

def getTempFolder() {
    "test2"
}

def getMainTitle() {
    "TEST2"
}

def init() {
    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/12_Monaco_Nizza_Cannes_Cassis_Marseille"
    append("$dir/", "10_03_54-1080p.jpg", "COMMENT", "2012.08.12 Monaco")
    append("$dir/", "10_27_52-1080p.jpg", "", "")
    append("$dir/", "10_44_29-1080p.jpg", "", "")
}

def createResult() {
    true
}

def cleanup() {
    true
}

def append(def input, def file, def comment, def title) {
    PATH+=(input)
    FILE+=(file)
    COMMENT+=(comment)
    TITLE+=(title)
}
