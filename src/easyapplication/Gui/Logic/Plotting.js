/////////
// Common
/////////

function headCommon() {
    const list = [
              '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>',
              '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=PT+Sans:400">',
              '<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">'
          ]
    return list.join('\n')
}

function chartHtml(head, chart, toolbar='') {
    const list = [
              '<!DOCTYPE html>',
              '<html>',
              '<head>',
              head,
              '</head>',
              '<body>',
              toolbar,
              '<script>',
              chart,
              '</script>',
              '</body>',
              '</html>'
          ]
    return list.join('\n')
}

////////
// Bokeh
////////

function bokehInfo() {
    const version = '2.4.3'
    return {
        version: version,
        url: `https://docs.bokeh.org/en/${version}`
    }
}

function bokehHtml(data, specs) {
    const head = bokehHead(specs)
    const chart = bokehChart(data, specs)
    const html = chartHtml(head, chart)
    return html
}

function bokehHeadScripts() {
    const baseSrc = 'https://cdn.pydata.org/bokeh/release'
    const version = bokehInfo().version
    const list = [
              `<script type="text/javascript" src="${baseSrc}/bokeh-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-widgets-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-tables-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-api-${version}.min.js"></script>`
          ]
    return list.join('\n')
}

function bokehHeadStyle(specs) {
    const list = [
              '<style type="text/css">',
              '* { ',
              '    margin: 0;',
              '    padding: 0;',
              '    box-sizing: border-box;',
              '}',
              'body {',
              '    overflow: hidden;',
              '    font-family: "PT Sans", sans-serif;',
              '}',
              '.bk-logo {',
              '    display: none !important;',
              '}',
              '.bk-toolbar.bk-above  {',
              `    position: absolute;`,
              `    z-index: 1;`,
              `    top: ${0.5 * specs.fontPixelSize}px;`,
              `    right: ${1.5 * specs.fontPixelSize}px;`,
              '}',
              '</style>'
          ]
    return list.join('\n')
}

function bokehHead(specs) {
    const list = [
            headCommon(),
            bokehHeadScripts(),
            bokehHeadStyle(specs)
          ]
    return list.join('\n')
}

function bokehChart(data, specs) {
    if (!data.hasMeasured && !data.hasCalculated && !data.hasPlotRanges) {
        return ""
    }
    // List of strings to be filled below
    let chart = []

    // Tooltips
    chart.push(bokehAddMainTooltip(data, specs))
    chart.push(bokehAddBraggTooltip(specs))

    // Data sources
    chart.push('const main_source = new Bokeh.ColumnDataSource()')
    // Charts array
    chart.push('const charts = []')

    // Main chart (top)
    chart.push(...bokehCreateMainChart(data, specs))
    chart.push(...bokehAddMainTools('main_chart'))
    chart.push(...bokehAddHiddenXAxis('main_chart', specs))
    chart.push(...bokehAddVisibleYAxis('main_chart', specs))
    if (data.hasBackground) {
        chart.push(...bokehAddBackgroundDataToMainChart(data, specs))
    }
    if (data.hasMeasured) {
        chart.push(...bokehAddMeasuredDataToMainChart(data, specs))
    }
    if (data.hasPhase) {
        chart.push(...bokehAddPhaseDataToMainChart(data, specs))
    }
    if (data.hasCalculated) {
        chart.push(...bokehAddCalculatedDataToMainChart(data, specs))
    }
    chart.push(`charts.push([main_chart])`)

    // Bragg peaks chart (middle)
    if (data.hasBragg) {
        chart.push(...bokehCreateBraggChart(data, specs))
        chart.push(...bokehAddBraggTools())
        chart.push(...bokehAddHiddenXAxis('bragg_chart', specs))
        chart.push(...bokehAddHiddenYAxis('bragg_chart'))
        chart.push(...bokehAddDataToBraggChart(data, specs))
        chart.push(`charts.push([bragg_chart])`)
    }

    // Difference chart (bottom)
    if (data.hasDifference) {
        chart.push(...bokehCreateDiffChart(data, specs))
        chart.push(...bokehAddMainTools('diff_chart'))
        chart.push(...bokehAddHiddenXAxis('diff_chart', specs))
        chart.push(...bokehAddVisibleYAxis('diff_chart', specs))
        chart.push(...bokehAddDataToDiffChart(data, specs))
        chart.push(...adjustDifferenceYRange())
        chart.push(`diff_chart.ygrid[0].ticker.desired_num_ticks = 3`)
        chart.push(`charts.push([diff_chart])`)
    }

    // xAxis chart (very bottom)
    chart.push(...bokehCreateXAxisChart(data, specs))
    chart.push(...bokehAddVisibleXAxis('xaxis_chart', specs))
    chart.push(...bokehAddHiddenYAxis('xaxis_chart'))
    chart.push(`charts.push([xaxis_chart])`)

    // Charts array grid layout
    chart.push(`const grid_options = {toolbar_location: "above"}`)
    chart.push(`const gridplot = new Bokeh.Plotting.gridplot(charts, grid_options)`)

    chart.push(...[
                   'function OnClick() {',
                   'main_chart.reset.emit()',
                   '//console.log("AAA", document.querySelector(".bk-tool-icon-reset"))',
                   '//console.log("BBB", document.getElementById("bk-tool-icon-reset"))',
                   '    //document.getElementById("bk-tool-icon-reset").click()',
                   '    document.querySelector(".bk-tool-icon-reset").click()',
                   '}'
               ])

    // Show charts
    if (typeof specs.containerId !== 'undefined') {
        chart.push(`Bokeh.Plotting.show(gridplot, "#${specs.containerId}")`)
    } else {
        chart.push(`Bokeh.Plotting.show(gridplot)`)
    }

    // Return as string
    return chart.join('\n')
}

// Bokeh charts

function bokehCreateMainChart(data, specs) {
    return [`const main_chart = new Bokeh.Plotting.figure({`,
            `   tools: "reset,undo,redo",`,

            `   height: ${specs.mainChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: new Bokeh.Range1d({`,
            `       start: ${data.ranges.min_x},`,
            `       end: ${data.ranges.max_x}`,
            `   }),`,
            `   y_range: new Bokeh.Range1d({`,
            `       start: ${data.ranges.min_y},`,
            `       end: ${data.ranges.max_y}`,
            `   }),`,

            `   y_axis_label: "${specs.yMainAxisTitle}",`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}",`,
            `   //border_fill_color: "red",`,

            `   min_border_right: ${1.5 * specs.fontPixelSize},`,
            `   min_border_top: ${0.5 * specs.fontPixelSize},`,
            `   min_border_bottom: ${0.5 * specs.fontPixelSize}`,
            `})`]
}

function bokehCreateBraggChart(data, specs) {
    const num_phases = Object.keys(data.bragg).length
    const y_margin = 0.65
    const y_min = -num_phases + 1 - y_margin
    const y_max = y_margin
    return [`const bragg_chart = new Bokeh.Plotting.figure({`,
            `   tools: "",`,

            `   height: ${specs.braggChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: main_chart.x_range,`,
            `   y_range: new Bokeh.Range1d({ start: ${y_min}, end: ${y_max} }),`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}",`,
            `   //border_fill_color: "green",`,

            `   min_border_top: ${0.5 * specs.fontPixelSize},`,
            `   min_border_bottom: ${0.5 * specs.fontPixelSize}`,
            `})`]
}

function bokehCreateDiffChart(data, specs) {
    return [`const diff_chart = new Bokeh.Plotting.figure({`,
            `   tools: "reset",`,

            `   height: ${specs.differenceChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: main_chart.x_range,`,

            `   y_axis_label: "${specs.yDifferenceAxisTitle}",`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}",`,
            `   //border_fill_color: "blue",`,

            `   min_border_top: ${0.5 * specs.fontPixelSize},`,
            `   min_border_bottom: ${0.5 * specs.fontPixelSize}`,
            `})`]
}

function bokehCreateXAxisChart(data, specs) {
    return [`const xaxis_chart = new Bokeh.Plotting.figure({`,
            `   tools: "",`,

            `   height: ${specs.xAxisChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: main_chart.x_range,`,
            `   y_range: new Bokeh.Range1d({ start: 0, end: 1 }),`,

            `   x_axis_label: "${specs.xAxisTitle}",`,

            `   outline_line_color: null,`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}",`,
            `   //border_fill_color: "orange",`,

            `   min_border_top: 0,`,
            `   min_border_bottom: 0`,
            `})`]
}

// Misc

function adjustDifferenceYRange() {
    return [`function differenceChartMeanY() {`,
            `    let ySum = 0, yCount = 0`,
            `    for (let i in main_source.data.x_diff) {`,
            `        if (diff_chart.x_range.start <= main_source.data.x_diff[i] && main_source.data.x_diff[i] <= diff_chart.x_range.end) {`,
            `            ySum += main_source.data.y_diff[i]`,
            `            yCount += 1`,
            `        }`,
            `    }`,
            `    if (yCount > 0) {`,
            `        return ySum / yCount`,
            `    }`,
            `    return 0`,
            `}`,

            `function differenceChartHalfRangeY() {`,
            `    const mainChartRangeY = main_chart.y_range.end - main_chart.y_range.start`,
            `    const mainChartAxesHeight = main_chart.height - main_chart.min_border_top - main_chart.min_border_bottom`,
            `    const differenceChartAxesHeight = diff_chart.height - diff_chart.min_border_top - diff_chart.min_border_bottom`,
            `    const differenceToMainChartHeightRatio = differenceChartAxesHeight / mainChartAxesHeight`,
            `    const differenceChartRangeY = mainChartRangeY * differenceToMainChartHeightRatio`,
            `    return 0.5 * differenceChartRangeY`,
            `}`,

            `diff_chart.y_range = new Bokeh.Range1d({`,
            `    start: differenceChartMeanY() - differenceChartHalfRangeY(),`,
            `    end: differenceChartMeanY() + differenceChartHalfRangeY()`,
            `})`,

            `main_chart.y_range.change.connect(function() {`,
            `    diff_chart.y_range.start = differenceChartMeanY() - differenceChartHalfRangeY()`,
            `    diff_chart.y_range.end = differenceChartMeanY() + differenceChartHalfRangeY()`,
            `})`]
}

// Bokeh tools

function bokehAddMainTools(chart) {
    return [`${chart}.add_tools(new Bokeh.HoverTool({tooltips:main_tooltip, point_policy:"snap_to_data", mode:"mouse"}))`,
            `${chart}.add_tools(new Bokeh.BoxZoomTool())`,
            `${chart}.toolbar.active_drag = "box_zoom"`,
            `${chart}.add_tools(new Bokeh.PanTool())`]
}

function bokehAddBraggTools() {
    return [`bragg_chart.add_tools(new Bokeh.HoverTool({tooltips:bragg_tooltip, point_policy:"snap_to_data", mode:"mouse"}))`]
}

// Bokeh axes

function bokehAddVisibleXAxis(chart, specs) {
    return [`${chart}.xaxis[0].axis_label_text_font = "PT Sans"`,
            `${chart}.xaxis[0].axis_label_text_font_style = "normal"`,
            `${chart}.xaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.xaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.xaxis[0].axis_label_standoff = ${specs.fontPixelSize - 5}`,
            `${chart}.xaxis[0].axis_line_color = null`,

            `${chart}.xaxis[0].major_label_text_font = "PT Sans"`,
            `${chart}.xaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.xaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.xaxis[0].major_label_standoff = 0`,
            `${chart}.xaxis[0].major_tick_line_color = null`,
            `${chart}.xaxis[0].major_tick_in = 0`,
            `${chart}.xaxis[0].major_tick_out = 0`,
            `${chart}.xaxis[0].minor_tick_line_color = null`,
            `${chart}.xaxis[0].minor_tick_out = 0`,

            `${chart}.xgrid[0].grid_line_color = null`]
}

function bokehAddHiddenXAxis(chart, specs) {
    return [`${chart}.xaxis[0].axis_label_text_font_size = "0px"`,
            `${chart}.xaxis[0].axis_line_color = null`,

            `${chart}.xaxis[0].major_label_text_font_size = "0px"`,
            `${chart}.xaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `${chart}.xaxis[0].major_tick_in = 0`,
            `${chart}.xaxis[0].major_tick_out = 0`,
            `${chart}.xaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `${chart}.xaxis[0].minor_tick_out = 0`,

            `${chart}.xgrid[0].grid_line_color = "${specs.chartGridLineColor}"`]
}

function bokehAddVisibleYAxis(chart, specs) {
    return [`${chart}.yaxis[0].axis_label_text_font = "PT Sans"`,
            `${chart}.yaxis[0].axis_label_text_font_style = "normal"`,
            `${chart}.yaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.yaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.yaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,
            `${chart}.yaxis[0].axis_line_color = null`,

            `${chart}.yaxis[0].major_label_text_font = "PT Sans"`,
            `${chart}.yaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.yaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.yaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `${chart}.yaxis[0].major_tick_in = 0`,
            `${chart}.yaxis[0].major_tick_out = 0`,
            `${chart}.yaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `${chart}.yaxis[0].minor_tick_out = 0`,

            `${chart}.ygrid[0].grid_line_color = "${specs.chartGridLineColor}"`]
}

function bokehAddHiddenYAxis(chart) {
    return [`${chart}.yaxis[0].axis_line_color = null`,

            `${chart}.yaxis[0].major_tick_in = 0`,
            `${chart}.yaxis[0].major_tick_out = 0`,
            `${chart}.yaxis[0].minor_tick_out = 0`,
            `${chart}.yaxis[0].major_label_text_font_size = "0px"`,

            `${chart}.ygrid[0].grid_line_color = null`]
}

// Bokeh data

function bokehAddBackgroundDataToMainChart(data, specs) {
    return [`main_source.data.x_bkg = [${data.background.x}]`,
            `main_source.data.y_bkg = [${data.background.y}]`,

            'const bkgLine = new Bokeh.Line({',
            '    x: { field: "x_bkg" },',
            '    y: { field: "y_bkg" },',
            `    line_color: "${specs.backgroundLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_dash: [4, 2],`,
            `    line_width: ${specs.backgroundLineWidth},`,
            '})',

            'main_chart.add_glyph(bkgLine, main_source)']
}

function bokehAddMeasuredDataToMainChart(data, specs) {


    return [`main_source.data.x_meas = [${data.measured.x}]`,
            `main_source.data.y_meas = [${data.measured.y}]`,
            `main_source.data.sy_meas = [${data.measured.sy}]`,
            `main_source.data.y_meas_upper = [${data.measured.y_upper}]`,
            `main_source.data.y_meas_lower = [${data.measured.y_lower}]`,

            `const measLineTop = new Bokeh.Line({`,
            `    x: { field: "x_meas" },`,
            `    y: { field: "y_meas_upper" },`,
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_alpha: 0.4,`,
            `    line_width: ${specs.measuredLineWidth}`,
            `})`,
            `const measLineBottom = new Bokeh.Line({`,
            `    x: { field: "x_meas" },`,
            `    y: { field: "y_meas_lower" },`,
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_width: ${specs.measuredLineWidth},`,
            `    line_alpha: 0.4`,
            `})`,
            `const measArea = new Bokeh.VArea({`,
            `    x: { field: "x_meas" },`,
            `    y1: { field: "y_meas_upper" },`,
            `    y2: { field: "y_meas_lower" },`,
            `    fill_color: "${specs.measuredAreaColor}",`,
            `    fill_alpha: 0.35`,
            `})`,

            `main_chart.add_glyph(measArea, main_source)`,
            `main_chart.add_glyph(measLineTop, main_source)`,
            `main_chart.add_glyph(measLineBottom, main_source)`]


}

function bokehAddCalculatedDataToMainChart(data, specs) {

    return [`main_source.data.x_calc = [${data.calculated.x}]`,
            `main_source.data.y_calc = [${data.calculated.y}]`,

            'const calcLine = new Bokeh.Line({',
            '    x: { field: "x_calc" },',
            '    y: { field: "y_calc" },',
            `    line_color: "${specs.calculatedLineColor}",`,
            `    line_width: ${specs.calculatedLineWidth},`,
            `    line_alpha: 0.8`,
            '})',

            'main_chart.add_glyph(calcLine, main_source)']
}

function bokehAddPhaseDataToMainChart(data, specs) {
    let out = []
    out.push('let phaseLine = new Bokeh.Line()')
    for (const phase_index in data.phase) {
        out.push(`main_source.data.x_phase_${phase_index} = [${data.phase[phase_index].x}]`)
        out.push(`main_source.data.y_phase_${phase_index}_upper = [${data.phase[phase_index].y_upper}]`)
        out.push(`main_source.data.y_phase_${phase_index}_lower = [${data.phase[phase_index].y_lower}]`)
        out.push(`const phaseLine_${phase_index} = new Bokeh.Line({`)
        out.push(`    x: { field: "x_phase_${phase_index}" },`)
        out.push(`    y: { field: "y_phase_${phase_index}_upper" },`)
        out.push(`    line_color: "${specs.phaseLineColor[phase_index]}",`)
        out.push(`    line_width: ${specs.phaseLineWidth},`)
        out.push(`    line_alpha: 0.6,`)
        out.push('})')
        out.push(`const phaseArea_${phase_index} = new Bokeh.VArea({`)
        out.push(`    x: { field: "x_phase_${phase_index}" },`)
        out.push(`    y1: { field: "y_phase_${phase_index}_upper" },`)
        out.push(`    y2: { field: "y_phase_${phase_index}_lower" },`)
        out.push(`    fill_color: "${specs.phaseLineColor[phase_index]}",`)
        out.push(`    fill_alpha: 0.1`)
        out.push('})')
        out.push(`main_chart.add_glyph(phaseArea_${phase_index}, main_source)`)
        out.push(`main_chart.add_glyph(phaseLine_${phase_index}, main_source)`)

    }
    return out
}

function bokehAddDataToBraggChart(data, specs) {


    let out = []
    for (const phase_index in data.bragg) {
                            console.log("---", phase_index, data.bragg[phase_index].x.slice(0,200) )
        out.push(`const bragg_source_${phase_index} = new Bokeh.ColumnDataSource()`)

        out.push(`bragg_source_${phase_index}.data.x_bragg = [${data.bragg[phase_index].x}]`)
        out.push(`bragg_source_${phase_index}.data.y_bragg = [${data.bragg[phase_index].y}]`)
        out.push(`bragg_source_${phase_index}.data.h_bragg = [${data.bragg[phase_index].h}]`)
        out.push(`bragg_source_${phase_index}.data.k_bragg = [${data.bragg[phase_index].k}]`)
        out.push(`bragg_source_${phase_index}.data.l_bragg = [${data.bragg[phase_index].l}]`)

        out.push(`const braggTicks_${phase_index} = new Bokeh.Scatter({`)
        out.push(`    x: { field: "x_bragg" },`)
        out.push(`    y: { field: "y_bragg" },`)
        out.push(`    marker: "dash",`)
        out.push(`    size: ${1.5 * specs.fontPixelSize},`)
        out.push(`    line_color: "${specs.braggTicksColor[phase_index]}",`)
        out.push(`    angle: ${Math.PI / 2.}`)
        out.push('})')
        out.push(`bragg_chart.add_glyph(braggTicks_${phase_index}, bragg_source_${phase_index})`)
    }
    return out
}

function bokehAddDataToDiffChart(data, specs) {




    return [`main_source.data.x_diff = [${data.difference.x}]`,
            `main_source.data.y_diff = [${data.difference.y}]`,
            `main_source.data.y_diff_upper = [${data.difference.y_upper}]`,
            `main_source.data.y_diff_lower = [${data.difference.y_lower}]`,

            `const diffLineTop = new Bokeh.Line({`,
            `    x: { field: "x_diff" },`,
            `    y: { field: "y_diff_upper" },`,
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.4,`,
            `    line_width: ${specs.differenceLineWidth}`,
            `})`,
            `const diffLineBottom = new Bokeh.Line({`,
            `    x: { field: "x_diff" },`,
            `    y: { field: "y_diff_lower" },`,
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.4,`,
            `    line_width: ${specs.differenceLineWidth}`,
            `})`,
            `const diffArea = new Bokeh.VArea({`,
            `    x: { field: "x_diff" },`,
            `    y1: { field: "y_diff_upper" },`,
            `    y2: { field: "y_diff_lower" },`,
            `    fill_color: "${specs.differenceAreaColor}",`,
            `    fill_alpha: 0.35`,
            `})`,

            `diff_chart.add_glyph(diffArea, main_source)`,
            `diff_chart.add_glyph(diffLineTop, main_source)`,
            `diff_chart.add_glyph(diffLineBottom, main_source)`]
}

// Bokeh tooltips

function bokehMainTooltipRow(color, label, value, sigma='') {
    return [`<tr style="color:${color}">`,
            `   <td style="text-align:right">${label}:&nbsp;</td>`,
            `   <td style="text-align:right">${value}</td>`,
            `   <td>${sigma}</td>`,
            `</tr>`]
}

function bokehAddMainTooltip(data, specs) {
    const x_meas = bokehMainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_meas{0.00}')
    const x_calc = bokehMainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_calc{0.00}')
    const y_meas = bokehMainTooltipRow(specs.measuredLineColor, 'meas', '@y_meas{0.0}', '&#177;&nbsp;@sy_meas{0.0}')
    const y_calc = bokehMainTooltipRow(specs.calculatedLineColor, 'calc', '@y_calc{0.0}')
    const y_bkg = bokehMainTooltipRow(specs.backgroundLineColor, 'bkg', '@y_bkg{0.0}')
    const y_diff = bokehMainTooltipRow(specs.differenceLineColor, 'diff', '@y_diff{0.0}')
    let y_phases = []
    for (const phase_index in data.phase) {
        if (typeof specs.phaseLineColor !== 'undefined') {
            y_phases.push(bokehMainTooltipRow(specs.phaseLineColor[phase_index], `phase ${phase_index}`, `@y_phase_${phase_index}_upper{0.0}`))
        }
    }

    let table = []
    table.push(...[`<div style="padding:2px">`, `<table>`, `<tbody>`])
    // x
    if (data.hasMeasured) {
        table.push(...x_meas)
    } else if (data.hasCalculated) {
        table.push(...x_calc)
    }
    // y
    if (data.hasMeasured) {
        table.push(...y_meas)
    }
    if (data.hasCalculated) {
        table.push(...y_calc)
    }
    for (const phase_index in data.phase) {
        if (typeof y_phases[phase_index] !== 'undefined') {
            table.push(...y_phases[phase_index])
        }
    }
    if (data.hasBackground) {
        table.push(...y_bkg)
    }
    if (data.hasDifference) {
        table.push(...y_diff)
    }
    table.push(...[`</tbody>`, `</table>`, `</div>`])

    const tooltip = JSON.stringify(table.join('\n'))
    return `const main_tooltip = (${tooltip})`
}

function bokehBraggTooltipSpan(color, label, value) {
    return `<span style="color:${color}">${label}:&nbsp;${value}</span>`
}

function bokehAddBraggTooltip(specs) {
    const x_bragg = bokehBraggTooltipSpan(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_bragg{0.00}')
    const hkl_bragg = bokehBraggTooltipSpan(specs.calculatedLineColor, 'hkl', '(@h_bragg @k_bragg @l_bragg)')

    const table = [`<div style="padding:2px">`,
                   x_bragg,
                   '&nbsp;',
                   hkl_bragg,
                   `</div>`]

    const tooltip = JSON.stringify(table.join('\n'))
    return `const bragg_tooltip = (${tooltip})`
}
