# Dimensions
margin =
  top: 20
  right: 20
  bottom: 30
  left: 50

width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom


# Date Parser
parseDate = d3.time.format("%d-%b-%y").parse


# Scales
x = d3.time.scale().range([0, width])
y = d3.scale.linear().range([height, 0])


# Axis
xAxis = d3.svg.axis().scale(x).orient("bottom")
yAxis = d3.svg.axis().scale(y).orient("left")


# Lines
xLine = (d) ->
  x d.date

yLine = (d) ->
  y d.close

line = d3.svg.line().x(xLine).y(yLine)

# Wait until the page is ready to draw the graph
$(document).ready ->

  # Create the SVG canvas
  svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

  # Load the data from an external file,
  # then draw the graph on the SVG canvas
  d3.csv "data/apple-stock.csv", (error, data) ->

    # Coerce the raw data into graphable data
    data.forEach (d) ->
      d.date = parseDate(d.date)
      d.close = +d.close

    # Set the graph domains to the bounds of the data
    x.domain d3.extent(data, (d) ->
      d.date
    )

    # Set the graph domains to the bounds of the data
    y.domain d3.extent(data, (d) ->
      d.close
    )

    # Draw the X axis, Y axis and the line
    svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
    svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Price ($)"
    svg.append("path").datum(data).attr("class", "line").attr "d", line
