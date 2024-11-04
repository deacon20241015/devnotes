import groovy.transform.Field

@Field PATH = []
@Field FILE = []
@Field COMMENT = []
@Field TITLE = []

def getTempFolder() {
    "output-example-input-test1"
}

def getMainTitle() {
    "Diverse Jahre"
}

def init() {
    def dir = "/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/05_Herceg_Novi"
    append("$dir/", "11_45_11-1-1080p.jpg", "TEST", "Title1")
    append("$dir/", "12_19_34-1-1080p.jpg", "TEST2", "")
    append("$dir/", "12_32_12-1-1080p.jpg", "", "")
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
