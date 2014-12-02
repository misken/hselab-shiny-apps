tabPanelAbout <- source("about.r")$value
shinyUI(pageWithSidebar(
  headerPanel(
    HTML(
      '<div id="stats_header">
			Rejection regions for hypothesis tests
			<a href="http://www.hselab.org" target="_blank">
			<div id="hse_logo" align="right">hselab.org</div>
			</a>
			</div>'
    ),
    "Rejection regions for hypothesis tests"
  ),
  sidebarPanel(
    wellPanel( radioButtons("dist","Distribution:",c("Z","t"),selected="Z"),
               numericInput("sig.level","Significance level:",0.05,min=0.005,max=0.250,step=0.005),
               checkboxInput("chkboxDensity", label = "Display pdf", value = TRUE)
     ),
    
    wellPanel( radioButtons("whichtails","Tails type:",c("Two tailed"='two',"Left tailed"='left',"Right tailed"='right'))
    ),
    
    wellPanel( textInput("set_tailcolor",label="Tail color",value="red"),
               textInput("set_fencecolor",label="Fence color",value="blue"),
               checkboxInput("chkboxTransparent", label = "Transparent plot area", value = TRUE)
    ),
    
    conditionalPanel(
      condition="input.dist == 't'",
      numericInput("tdf","Degrees of Freedom",15)
    ),
    
    wellPanel(
      downloadButton("dlCurPlot", "Download Graphic")
    )
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Plot",plotOutput("plot")),
      tabPanel("Debug",verbatimTextOutput("debugger")),
      tabPanelAbout()
    )
  )
))