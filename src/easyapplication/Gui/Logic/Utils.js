function prettyXml(xml, tab = '    ')
{
    let formatted = ''
    let indent = ''

    xml.split(/>\s*</).forEach(function(node)
    {
        if (node.match( /^\/\w/ ))
            indent = indent.substring(tab.length)

        formatted += indent + '<' + node + '>\r\n'

        if (node.match( /^<?\w[^>]*[^\/]$/ ))
            indent += tab
    })

    return formatted.substring(1, formatted.length-3);
}

function prettyJson(json, tab = '    ')
{
    return JSON.stringify(json, null, tab.length)
}


function osPathSep() {
    if (Qt.platform.os === "windows") {
		return '\\'
	}
	return '/'
}	

// converts a URL to a local file path
function urlToLocalFile(url)
{	
    if (Qt.platform.os === "windows")
    {
        return url.replace('file:///', '').split('/').join('\\')
    }
    else if (Qt.platform.os === "osx" || Qt.platform.os === "linux" || Qt.platform.os === "unix")
    {
        return url.replace('file://', '')
    }
    else
    {
        return url
    }
}

function isQmlScene()
{
    const runnerPath = Qt.application.arguments[0]
    if (runnerPath.includes('qmlscene'))
    {
        return true
    }
    return false
}

// XMLHttpRequest: Using PUT on a local file is disabled by default.
// Set QML_XHR_ALLOW_FILE_WRITE to 1 to enable this feature.
// E.g., 'QML_XHR_ALLOW_FILE_WRITE=1 qml main.qml'
function writeFile(url, content) {
    const method = "PUT"
    const async = false
    const request = new XMLHttpRequest()
    request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                print(`Succeeded to write file: '${url}'`)
            } else {
                print(`Failed to write file: '${url}'. Status: ${request.status}`)
            }
        }
    }
    request.open(method, url, async)
    request.send(content)
}

// XMLHttpRequest: Using GET on a local file is disabled by default.
// Set QML_XHR_ALLOW_FILE_READ to 1 to enable this feature.
// E.g., 'QML_XHR_ALLOW_FILE_READ=1 qml main.qml'
function readFile(url) {
    const method = "GET"
    const async = false
    const request = new XMLHttpRequest()
    request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                print(`Succeeded to read file: '${url}'`)
            } else {
                print(`Failed to read file: '${url}'. Status: ${request.status}`)
            }
        }
    }
    request.open(method, url, async)
    request.send()
    return request.responseText
}




function toFixed(value, digitsCount = 4)
{
    if (typeof value === 'undefined')
    {
        return ""
    }
    else if (typeof value == 'number')
    {
        return value.toFixed(digitsCount)
    }
    else
    {
        return value
    }
}

function toMaxPrecision(value, digitsCount = 5) {
    if (typeof value === 'number') {
        return  Number(value.toPrecision(digitsCount)).toString()
    } else if (typeof value === 'string') {
        return value
    } else if (typeof value === 'undefined') {
        return ""
    } else {
        console.error(`Value ${value} with type '${typeof value}' is not supported`)
        return ""
    }
}

function toDefaultPrecision(x) {
    const defaultPrecision = 3
    return Number(x.toPrecision(defaultPrecision)).toString()
}

function toSinglePrecision(x) {
    if (x === 0) {
        return ''
    }
    return Number(x.toPrecision(1)).toString()
}

function toErrSinglePrecision(x, dx) {
    dx = Number(dx.toPrecision(1))
    return toFixedUncertainty(x, dx)
}

function toSamePrecision(x, y) {
    return toFixedUncertainty(x, y)
}

// https://gist.github.com/davidselassie/3838522

function roundAway(x) {
  // Rounds a number to the next integer away from 0
  //
  // Args:
  //   x - Number to round
  // Returns:
  //   rounded - Next integer from x away from 0

  if (x >= 0) {
    return Math.ceil(x)
  } else {
    return Math.floor(x)
  }
}

function roundToIndex(x, index) {
  // Rounds a number to a given index around the decimal point
  //
  // Args:
  //   x - Number to round
  //   index - Index of the least significan digit; 0 is the decimal point
  // Returns:
  //   rounded - Number rounded using the least signficant digit

  var power = Math.pow(10, -index)
  return Math.round(x * power) / power
}

function toFixedUncertainty(x, dx) {
  // Returns the string representation of a number correctly rounded given
  // an uncertainty value.
  //
  // Args:
  //   x - Number to print
  //   dx - Uncertainty in x
  // Returns:
  //   x_string - String with x properly rounded given dx

  // If there is no uncertainty, return the entire number
  if (dx === undefined || dx === 0) {
      ////return x.toString();
      return toDefaultPrecision(x)
  }

  // Find out the least significant digit using the uncertainty
  var roundingIndex = roundAway(Math.log(dx) / Math.log(10))
  // Round using that number of digits.
  var roundedString = roundToIndex(x, roundingIndex).toString()

  // Now we have to only show the digits that are significant

  // If we're rounding a whole number
  if (roundingIndex >= 0) {
    // Find out if we want more significant digits that we have
    var overshot = roundingIndex - roundedString.length + 1
    if (overshot <= 0) {
      return roundedString;
    // If so, add more 0s on the beginning.
    } else {
      return Array(overshot + 1).join('0') + roundedString;
    }
  // If we're rounding to a decimal place
  } else {
    var decimalIndex = roundedString.indexOf('.');
    // If there isn't a '.', we're rounding to 0 if we got here.
    if (decimalIndex < 0) {
      roundedString = '0.'
      decimalIndex = 1
    }

    // Find out if the least significant digit is off the end of the number
    var lastIndex = decimalIndex + 1 - roundingIndex
    var overshot = lastIndex - roundedString.length
    if (overshot <= 0) {
      return roundedString.slice(0, lastIndex)
    // If so, add more 0s to show the precision we have.
    } else {
      return roundedString + Array(overshot + 1).join('0')
    }
  }
}


// Consider using python backend
// Either
// from uncertainties import ufloat
// or
// from decimal import Decimal
// paramStr = str(Decimal(valueStr).quantize(Decimal(errorStr)))  # Sets value precision to be the same as for the standard uncertainty
