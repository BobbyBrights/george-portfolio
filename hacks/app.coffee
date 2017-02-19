# Import file "Testing" (sizes and positions are scaled 1:2)
$ = Framer.Importer.load("imported/Testing@2x")

# Shortcut Layer Names from sketch["myLayer"] -> sketch
Utils.globalLayers($)

# Save Original Frame Position of Each One
layer.originalFrame = layer.props for layer in Framer.CurrentContext.getLayers()

# Material Design Curve
Framer.Defaults.Animation = 
	curve: "spring(230,30,0,0.01)"
Layer::animateTo = (properties) ->
	thisLayer = this
	thisLayer.animationTo = new
		layer: thisLayer
		properties: properties
	thisLayer.animationTo.start()

artboards = [artboardA,artboardB, artboardC]

# Pageviews
pages = new PageComponent
	size: Screen.size
for artboard in artboards
	artboard.visible = true
	pages.addPage(artboard)

indicatorDots.superLayer = Framer.Device.Screen
pages.scrollVertical = false

# shortcut to all TextLayers
TextLayers = [screen1H1, screen1H2, screen2H1, screen2H2, screen3H1, screen3H2]

# shortcut to all illustrations
ArtImages = [ screen1IMG1, screen1IMG2, screen2IMG1, screen2IMG2, screen3IMG1, screen3IMG2]

# Array that will store our Icons
IconDotsImages = [ screen1Icon, screen2Icon, screen3Icon ]

# Array that will store our layers
allIndicators = []
allIcondots = []	
numofPages = 3

# hidden text/images
for text in TextLayers
	text.opacity = 0
	text.y = text.originalFrame.y + 10
for art in ArtImages
	art.scale = 0.9
	art.opacity = 0
	art.y = art.originalFrame.y + 30
for i in [0...3]	
	indicator = new Layer 
		borderColor: "#fff"
		borderWidth: 5
		backgroundColor: null
		width: 36, height: 36
		opacity: 0.4
		x: 60 * (i+1), y: Screen.height-100
		borderRadius: '50%'
		superLayer: pages

	# Stay centered regardless of the amount of pages
	indicator.x += (Screen.width / 2) - (indicator.width*1.5 * numofPages)
	
		# Add icon inside indicator
	IconDots = new Layer 
		backgroundColor: null
		width: 12, height: 12
		x: 5,
		y: 5 
		borderRadius: '50%'
		superLayer: indicator,
		opacity: 0
			
	
	# Increase size
	indicator.states.add(
		active: {
			backgroundColor: '#fff',
			scale: 2
			opacity: 0.4
		},
		previous: {
			backgroundColor: '#fff',
			scale: 1
			opacity: 0.4
		}
	)
	indicator.states.animationOptions = time: 0.5
	
	# Show icon
	IconDots.states.add(
		active: {
			opacity: 1	
		}
	)
	IconDots.states.animationOptions = time: 0.5
	
	IconDotsImages[i].superLayer = IconDots
	IconDotsImages[i].x = -10
	IconDotsImages[i].width = 36
	IconDotsImages[i].height = 36
	IconDotsImages[i].y = -10
	
	# Store indicators in our array
	allIndicators.push(indicator)
	allIcondots.push(IconDots)
	
# Set indicator for current page
current = pages.horizontalPageIndex(pages.currentPage)
allIndicators[current].states.switch("active")
allIcondots[current].states.switch("active")

# Default animation
screen1H1.animate
	properties: { opacity: 1, y: screen1H1.originalFrame.y }
	time: 0.35
	curve: "ease-out"
	delay: 0.1
screen1H2.animate
	properties: { opacity: 1, y: screen1H2.originalFrame.y }
	time: 0.35
	curve: "ease-out"
	delay: 0.1
screen1IMG1.animate
	properties: { opacity: 1, scale: 1, y: screen1IMG1.originalFrame.y }
	time: 0.35
	curve: "ease-out"
screen1IMG2.animate
	properties: { opacity: 1, scale: 1, y: screen1IMG2.originalFrame.y }
	time: 0.35
	curve: "ease-out"

# When the page changes, shit starts animating
pages.on "change:currentPage", ->
	cPage = pages.horizontalPageIndex(pages.currentPage)
	
	
	
	# Animate all text & illustrations
	for text in TextLayers
		text.animate
			properties: { opacity: 0, y: text.originalFrame.y + 10 }
			time: 0.2
			curve: "ease-in"
			
	for art in ArtImages
		art.animate
			properties: { scale: 0.9, opacity: 0, y: art.originalFrame.y + 30 }
			time: 0.2
			curve: "ease-in"
			
	IconDots.states.switch("default") for IconDots in allIcondots

	current = pages.horizontalPageIndex(pages.currentPage)
	allIcondots[current].states.switch("active")
	
	for key, indicator of allIndicators
		if parseInt(key) == current
			indicator.states.switch("active")
		else if current<parseInt(key)
			indicator.states.switch("default")
		else 
			indicator.states.switch("previous")

	# Current slide Animation
	$["screen#{cPage + 1}H1"].animate
		properties: { opacity: 1, y: $["screen#{cPage + 1}H1"].originalFrame.y}
		curve: "spring(260,30,0,0.01)"
		delay: 0.3

	$["screen#{cPage + 1}H2"].animate
		properties: { opacity: 1, y: $["screen#{cPage + 1}H2"].originalFrame.y}
		curve: "spring(260,30,0,0.01)"
		delay: 0.3

	$["screen#{cPage + 1}IMG1"].animate
		properties: { opacity: 1, scale: 1, y: screen1IMG1.originalFrame.y }
		curve: "spring(200,20,0)"
		delay: 0.15

	$["screen#{cPage + 1}IMG2"].animate
		properties: { opacity: 1, scale: 1, y: screen1IMG2.originalFrame.y }
		curve: "spring(200,20,0)"
		delay: 0.15


