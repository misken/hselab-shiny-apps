library(shiny)
library(ggplot2)


expr.Z <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,sqrt(2*pi))~e^{frac(-1,2)})*x^scriptscriptstyle("2"))
                                  ~~~~displaystyle(list(paste(-infinity<x) <infinity)
)))

expr.t <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma~bgroup("(",frac(nu+1,2),")"),sqrt(nu*pi)~Gamma~bgroup("(",frac(nu,2),")"))~bgroup("(",1+frac(x^2,nu),")")^{-frac(nu+1,2)})
                                  ~~~~displaystyle(atop(paste(-infinity<x) <infinity, nu > 0))
)))

shinyServer(function(input,output){
  
  # Reactive elements related to the user inputs
  
  # Z or t
  dist <- reactive({
    return(input$dist)
    })
  
  # Type I error
  siglevel <- reactive({
    return(input$sig.level)
  })
  
  # Two, left, or right
  numtails <- reactive({
    return(input$whichtails)
  })
  
  # Degrees of freedom for t-distribution. All kinds of pain
  # due to originally naming this variable 'df' - which happens to be the
  # same name as the associated argument in functions like dt(), qt(), and rt().
  tdf <- reactive({
    return(input$tdf)
  })
  
  bDisplayPDF <- reactive({
    return(input$chkboxDensity)
  })
  

  
  transparent <- reactive({
    return(input$chkboxTransparent)
  })
  
  # Tail and fence colors
  tailcolor <- reactive({
    return(input$set_tailcolor)
  })
  
  fencecolor <- reactive({
    return(input$set_fencecolor)
  })
  
  # TODO - add xkcd style plot option :)

 
  
  # Main plotting function
  doPlot <- function(){
      
    x <- seq(-5,5,0.01)
      
    if (numtails() == "two") {
        tailalpha <- siglevel()/2
        tails <- 2
    } else {
        tailalpha <- siglevel()
        if (numtails() == "left") {
          tails <- -1
      } else {
          tails <- 1
      }
    }
      
    if (input$dist=="t") {
        
        # Generate prob density function over the x values
        pdf <- dt(x,input$tdf)
        
        # Get left-tailed crit value and make a nice informative title
        critvalue <- qt(tailalpha,input$tdf)
        plottitle <- paste("Rejection region based on ",dist(),
                           " distribution with df=",input$tdf," and alpha=",formatC(tailalpha,3),sep="")
        
    } else if (input$dist=="Z") {
        pdf <- dnorm(x)
        # Get left-tailed crit value and make a nice informative title
        critvalue <- qnorm(tailalpha)
        plottitle <- paste("Rejection region based on ",dist(),
                           " distribution and alpha=",formatC(tailalpha,3),sep="")
      } else {
        # Shouldn't get here but will generate normal if we somehow do. 
        pdf <- dnorm(x)
        critvalue <- qnorm(tailalpha)
        plottitle <- paste("Rejection region based on ",dist(),
                           " distribution and alpha=",formatC(alpha,3),sep="")
    }
      
    # Create dataframe based on x,y data
    dd <- data.frame(x,pdf)
      
    # Plot density as line plot
    rejplot <- qplot(x,pdf,data=dd,geom="line")
    rejplot <- rejplot + ggtitle(plottitle) 
      
    plottitleformat <- element_text(lineheight=3, face="bold", color="black", size=14)
      
    if (transparent()) {
        rejplot <- rejplot + theme_bw() + labs(title=plottitle, x="X", y="density") + theme(plot.title = plottitleformat)
    } else {
        
      rejplot <- rejplot + labs(title=plottitle, x="X", y="density") + theme(plot.title = plottitleformat)
    }
           
    # Fill left tail if needed
    if (tails==-1 || tails==2) {
        # The geom_ribbon provides the fill and geom_vline the vertical "fence"
        rejplot <- rejplot + geom_ribbon(data=subset(dd,x <= critvalue),aes(ymax=pdf),ymin=0,
                                         fill=tailcolor(),colour=NA,alpha=0.5) +
          geom_vline(aes(xintercept=critvalue), color=fencecolor(), linetype="dashed", size=1)
        
      rejlabel <- paste("Reject H0 if","\n", "test stat < ",formatC(critvalue,4),".")
      # Annotate with a rejection region message
      rejplot <- rejplot + annotate("text", x = -3.75, y = 0.10, label = rejlabel)
    }
    
    # Fill right tail if needed
    if (tails==1 || tails==2) {
        rejplot <- rejplot + geom_ribbon(data=subset(dd,x >= -critvalue),aes(ymax=pdf),ymin=0,
                                         fill=tailcolor(),colour=NA,alpha=0.5) +
          geom_vline(aes(xintercept = -critvalue), color=fencecolor(), linetype="dashed", size=1)
        
        rejlabel <- paste("Reject H0 if","\n", "test stat > ",formatC(-critvalue,4),".")
        rejplot <- rejplot + annotate("text", x = 3.75, y = 0.10, label = rejlabel)
    }
    
    
    # Annotate plot with pdf of Z or t
    #
    # Wasted crazy amounts of time figuring this out.
    # Creating the following object containing the expression we want R to treat as Tex was
    # no problem. It's getting ggplot2's annotate to accept it. It seems with base plot you can
    # simple set any text label equal to the desired plotmath expression. In ggplot2, need
    # also to set the parse=T flag. The tricky part for me was realizing that I needed to wrap
    # the expession variable in as.character() so that ggplot2 treated it as a string that needed
    # to be parsed. Anyhoo, now it works.
    
    if (bDisplayPDF()) {
      pdfexpr <- get(paste("expr",input$dist,sep="."))
      rejplot <- rejplot + annotate(geom='text', x = 3.0, y = 0.30, size =  3, label = as.character(pdfexpr), parse = TRUE)
    }
    
    # Return the plot object so it can be rendered by Shiny
    return(rejplot)  
      
  }
  

  # Output plot                                 
  output$plot <- renderPlot({
    p <- doPlot()
    # Use print() with plots created using ggplot2
    print(p)
  })
  
  # I used this tab for debugging
  output$debugger <- renderText({
    paste("Dist:",dist(),"Sig Level:",siglevel(),"Num Tails:",numtails(),"Display PDF:",bDisplayPDF())
  })

  # Download PNG file - IMPORTANT: Download only works from within browser. For some
  #                                reason it doesn't work in R Studio. 
  #                                http://stackoverflow.com/questions/14810409/save-plots-made-in-a-shiny-app
  output$dlCurPlot <- downloadHandler(
    filename = function() { paste(input$dist, '_', input$whichtails, '_', siglevel(), '.png', sep='') },
    content = function(file){
      png(file,width=7,height=5,units='in',res=300)
      print(doPlot())
      dev.off()
      
      # Here's an alternate approach to the above 3 lines. Uses ggsave()
      # png(file)
      # ggsave(file, plot=doPlot(), device=png, width=800, height=800, limitsize=FALSE)
    })
  
})