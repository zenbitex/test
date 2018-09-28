 @DepthUI = flight.component ->
  @attributes
    chart: '#depths'

  @refresh = (event, data) ->
    chart = @select('chart').highcharts()
    chart.series[0].setData data.bids.reverse(), false
    chart.series[1].setData data.asks, false
    chart.xAxis[0].setExtremes(data.low, data.high)
    chart.redraw()

  @initChart = (data) ->
    @select('chart').highcharts
      chart:
        margin: 0
        height: 100
        backgroundColor: 'rgba(0,0,0,0)'
        connectEnds: false

      title:
        text: ''

      credits:
        enabled: false

      legend:
        enabled: false

      rangeSelector:
        enabled: false

      xAxis:
        labels:
          enabled: false

      yAxis:
        min: 0
        gridLineColor: 'transparent'
        gridLineDashStyle: 'ShortDot'
        title:
          text: ''
        labels:
          enabled: false
      series : [{
        name : gon.i18n.bid
        type : 'area'
        fillColor: 'rgba(67, 188, 235, 0.4)'
        lineColor: 'rgba(67, 188, 235, 1)'
        color: 'transparent'
        animation:
          duration: 1000
      },{
        name: gon.i18n.ask
        type: 'area'
        animation:
          duration: 1000
        fillColor: 'rgba(181, 91, 147, 0.4)'
        lineColor: 'rgb(181, 91, 147)'
        color: 'transparent'
        markers:
          fill: 'blue'
          stroke: '2'
          color: 'black'
      }]


      tooltip:
        valueDecimals: 4
        headerFormat:
          """
          <table class="depths-table"><tr>
            <th><span class="depth-head">{series.name}</span> #{gon.i18n.chart.price}</th><th>#{gon.i18n.chart.depth}</th>
          </tr>
          """ 
        pointFormat: 
           # if {series.name}=="Bid"              
             # return 
           '<tr><td style="color:{series.color}">{point.x}</td><td style="color:{series.color}"=>{point.y}</td></tr>'
           # else 
           # return 
           # '<tr><td class="depths_depth">{point.x}</td><td class="depths_depth">{point.y}</td></tr>'
                  
               
        footerFormat: '</table>'
        borderWidth: 0
        backgroundColor: 'rgba(0, 0, 0, 0)'
        borderRadius: 0
        shadow: false
        useHTML: true
        shared: true
        positioner: -> {x: 128, y: 28}

      series : [{
        name : gon.i18n.bid
        type : 'area'
        fillColor: 'rgba(67, 188, 235, 0.4)'
        lineColor: 'rgba(67, 188, 235, 1)'
        color: 'rgba(67, 188, 235, 1)'
        animation:
          duration: 1000
        marker:
          symbol: 'diamond'
          enabled: false,
          states:  
            select:  
              enabled: true
              symbol: 'diamond'
              stroke: '3'
              fillColor: 'black'
              #color: 'rgba(67, 188, 235, 1)'
              color: 'black'
            hover:
              enaled: true
              symbol: 'diamond'
              stroke: '3'
              fillColor: 'black'
              #color: 'rgba(67, 188, 235, 1)'
              color: 'black'

          
      },{
        name: gon.i18n.ask
        type: 'area'
        animation:
          duration: 1000
        fillColor: 'rgba(181, 91, 147, 0.4)'
        lineColor: 'rgb(181, 91, 147)'
        color: 'rgb(181, 91, 147)'
        mouseTracking: true
        marker:
          symbol: 'diamond'
          enabled: false,
          states:                        
            select:
              enabled: true 
              symbol: 'diamond'
              stroke: '3'
              fillColor: 'black'
              #color: 'rgba(67, 188, 235, 1)'
              color: 'black'
            hover:
              enabled: true
              symbol: 'diamond'
              stroke: '3'
              fillColor: 'black'
              #color: 'rgba(67, 188, 235, 1)'
              color: 'black'

      }]


  @after 'initialize', ->
    @initChart()
    @on document, 'market::depth::response', @refresh
    @on document, 'market::depth::fade_toggle', ->
      @$node.fadeToggle()

    @on @select('close'), 'click', =>
      @trigger 'market::depth::fade_toggle'
