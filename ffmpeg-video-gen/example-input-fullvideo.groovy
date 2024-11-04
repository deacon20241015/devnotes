import groovy.transform.Field

@Field PATH = []
@Field FILE = []
@Field COMMENT = []
@Field TITLE = []

def getTempFolder() {
    "diverse.jahre"
}

def getMainTitle() {
    "Diverse Jahre"
}

def init() {
    def dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/04_Sutomore_Budva_Kotor"
    append("$dir/", "08_06_17-1080p.jpg", "Sutomore", "2012.08.04 Montenegro")
    append("$dir/", "13_34_37-1080p.jpg", "Budva", "")
    append("$dir/", "CLIP0096_Kotor_260grad.AVI", "Kotor", "")
    append("$dir/", "CLIP0101.AVI", "", "")
    append("$dir/", "17_05_43-1080p.jpg", "", "")
    append("$dir/", "17_11_20-1080p.jpg", "", "")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/05_Herceg_Novi"
    append("$dir/", "CLIP0123.AVI", "Herceg Novi", "")
    append("$dir/", "11_45_11-1-1080p.jpg", "", "")
    append("$dir/", "12_19_34-1-1080p.jpg", "", "")
    append("$dir/", "12_32_12-1-1080p.jpg", "", "")
    append("$dir/", "CLIP0127_Herceg_Novi_360grad.AVI", "", "")
    append("$dir/", "14_20_15-1-1080p.jpg", "", "")
    append("$dir/", "CLIP0130_Herceg_Novi_360grad.AVI", "", "")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/12_Monaco_Nizza_Cannes_Cassis_Marseille"
    append("$dir/", "10_03_54-1080p.jpg", "Monaco", "2012.08.12 Monaco")
    append("$dir/", "10_27_52-1080p.jpg", "", "")
    append("$dir/", "10_44_29-1080p.jpg", "", "")
    append("$dir/", "13_51_30-1080p.jpg", "Cannes", "2012.08.12 Frankreich")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/13_Marseille"
    append("$dir/", "10_05_41-1080p.jpg", "Marseille", "")
    append("$dir/", "10_14_45-1080p.jpg", "", "")
    append("$dir/", "CLIP0032_Marseille_from_the_Catedral.AVI", "", "")
    append("$dir/", "15_08_59-1080p.jpg", "", "")
    append("$dir/", "15_22_07-1080p.jpg", "", "")
    append("$dir/", "15_22_39-1080p.jpg", "", "")
    append("$dir/", "16_31_36-1080p.jpg", "", "")
    append("$dir/", "16_34_28-1080p.jpg", "", "")
    append("$dir/", "CLIP0040_Marseille_on_top_of_Hills_to_Calanques.AVI", "", "")
    append("$dir/", "CLIP0041_Marseille_Calanques.AVI", "", "")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2012/08_Interrail_Europa/14_Irun_San_Sebastian"
    append("$dir/", "13_04_24-1080p.jpg", "San Sebastian", "2012.08.14 Spanien")
    append("$dir/", "13_29_09-1080p.jpg", "", "")
    append("$dir/", "13_36_45-1080p.jpg", "", "")
    append("$dir/", "14_27_26-1080p.jpg", "", "")
    append("$dir/", "CLIP0054_San_Sebastian.AVI", "", "")
    append("$dir/", "14_27_57-1080p.jpg", "", "")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2013/05/03_zagreb_perkovac_sibenik"
    append("$dir/", "00011_sibenik_old_town.avi", "Sibenik", "2013.05.04 Kroatien")
    append("$dir/", "14_08_11-1080p.jpg", "", "")
    append("$dir/", "14_11_18-1080p.jpg", "", "")
    append("$dir/", "00017_sibenik_traditionell_msuic_and_dance.avi", "", "")

    dir="/media/oliver/Data/multimedia_1080p/multimedia_bis_inkl_2020/2013/08_skopje_nis_trebinje/19_herceg_novi_kotor_budva_ulcinj"
    append("$dir/", "10_38_24-1080p.jpg", "Kotor", "2013.08.19 Montenegro")
    append("$dir/", "10_51_26-1080p.jpg", "", "")
    append("$dir/", "10_57_32-1080p.jpg", "", "")
    append("$dir/", "00283_budva_bus_gute_musik.avi", "Anreise nach Budva", "")
    append("$dir/", "12_45_32-1080p.jpg", "Budva", "")
    append("$dir/", "13_00_24-1080p.jpg", "", "")
    append("$dir/", "13_02_54-1080p.jpg", "", "")
    append("$dir/", "13_08_26-1080p.jpg", "", "")
    append("$dir/", "13_26_15-1080p.jpg", "", "")
    append("$dir/", "17_45_22-1080p.jpg", "Ulcinj", "")
    append("$dir/", "18_13_21-1080p.jpg", "", "")
    append("$dir/", "00295.avi", "", "")
    append("$dir/", "18_15_51-1080p.jpg", "", "")
    append("$dir/", "00303_ulcinj.avi", "", "")
}

def createResult() {
    false
}

def cleanup() {
    false
}

def append(def input, def file, def comment, def title) {
    PATH+=(input)
    FILE+=(file)
    COMMENT+=(comment)
    TITLE+=(title)
}
