pragma Singleton

import QtQuick

QtObject {

    // Load fonts
    property FontLoader ptSansRegular: FontLoader { source: fontPath("PT_Sans", "PTSans-Regular.ttf") }
    property FontLoader ptSansBold: FontLoader { source: fontPath("PT_Sans", "PTSans-Bold.ttf") } // font.bold: true

    property FontLoader ptMono: FontLoader { source: fontPath("PT_Mono", "PTMono-Regular.ttf") }

    property FontLoader encodeSansRegular: FontLoader { source: fontPath("Encode_Sans", "EncodeSans-Regular.ttf") }
    property FontLoader encodeSansLight: FontLoader { source: fontPath("Encode_Sans", "EncodeSans-Light.ttf") } // font.weight: Font.Light

    property FontLoader encodeSansCondensedRegular: FontLoader { source: fontPath("Encode_Sans_Condensed", "EncodeSansCondensed-Regular.ttf") }
    property FontLoader encodeSansCondensedExtraLight: FontLoader { source: fontPath("Encode_Sans_Condensed", "EncodeSansCondensed-ExtraLight.ttf") } // font.weight: Font.ExtraLight

    property FontLoader encodeSansExpandedRegular: FontLoader { source: fontPath("Encode_Sans_Expanded", "EncodeSansExpanded-Regular.ttf") }
    property FontLoader encodeSansExpandedLight: FontLoader { source: fontPath("Encode_Sans_Expanded", "EncodeSansExpanded-Light.ttf") } // font.weight: Font.Light

    property FontLoader nunitoRegular: FontLoader { source: fontPath("Nunito", "Nunito-Regular.ttf") }
    property FontLoader nunitoLight: FontLoader { source: fontPath("Nunito", "Nunito-Light.ttf") }  // font.weight: Font.Light
    property FontLoader nunitoSemiBold: FontLoader { source: fontPath("Nunito", "Nunito-SemiBold.ttf") } // font.weight: Font.DemiBold

    property FontLoader fontAwesomeSolid: FontLoader { source: fontPath("FontAwesome", "Font Awesome 5 Free-Solid-900.otf") }

    // Font families
    readonly property string fontFamily: ptSansRegular.name
    readonly property string fontSource: ptSansRegular.source

    readonly property string monoFontFamily: ptMono.name

    readonly property string secondFontFamily: encodeSansRegular.name
    readonly property string secondCondensedFontFamily: encodeSansCondensedRegular.name
    readonly property string secondExpandedFontFamily: encodeSansExpandedRegular.name

    readonly property string thirdFontFamily: nunitoRegular.name

    readonly property string iconsFamily: fontAwesomeSolid.name

    // Logic
    function fontPath(fontDirName, fontFileName) {
        const fontsDirPath = Qt.resolvedUrl("../Resources/Fonts")
        return fontsDirPath + "/" + fontDirName + "/" + fontFileName
    }

}
