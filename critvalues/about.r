function(){
  tabPanel("About",
           


HTML('This is my first RStudio Shiny application. I wanted to learn <a class="reference external" href="http://www.rstudio.com/shiny/">Shiny, a way to make R based interactive web based apps</a>, and at the same time produce something at least a little useful. While creating a solution guide for a hypothesis testing assignment I had assigned in my statistics class, I realized it was a pain to create little plots showing rejection regions for two sample tests on the mean (based either on Z or t distribution). Hmm, seemed like a good candidate for a Shiny app. The user can specify the distribution, the significance level, which tails to show, and (eventually) some style related things like colors. The resulting plot can be downloaded to a PNG file. I then inserted the file into my homework solution guide. While there is not a whole lot of code needed for this app, there were numerous &quot;gotchas&quot; and much trial and error. I am super grateful to the folks at the <a class="reference external" href="http://www.snap.uaf.edu/">Scenarios Network for Alaska &amp; Arctic Planning</a> who have created numerous <a class="reference external" href="http://blog.snap.uaf.edu/">Shiny applications and tutorials and have shared them via their blog</a>. I learned much from their examples and &quot;borrowed&quot; many ideas from their series of <a class="reference external" href="http://blog.snap.uaf.edu/2013/05/20/introducing-r-shiny-web-apps/">introductory tutorials on plotting random variable distributions</a> . Hopefully this is the first of many Shiny apps for me. This post is not a Shiny tutorial. If you have no experience with Shiny, start at <a class="reference external" href="http://rstudio.github.io/shiny/tutorial/">http://rstudio.github.io/shiny/tutorial/</a>.'),
br(),
br(),
HTML('<div style="clear: left;"><img src="http://www.gravatar.com/avatar/fc045fe50396af924966567e76833cca.png" alt="" style="float: left; margin-right:5px" /></div>'),
strong('Author'),
p('Mark Isken',br(),
a('School of Business Administration at Oakland University', href="http://www.sba.oakland.edu/faculty/isken/", target="_blank"),
'|',
a('Blog', href="http://hselab.org/", target="_blank"),
'|',
a('LinkedIn', href="http://www.linkedin.com/pub/mark-isken/a/633/48/", target="_blank")  
),
br(),

div(class="row-fluid",
strong('Code'),
p('Source code available in my',
a('hselab-shiny-apps GitHub repo', href='https://github.com/misken/hselab-shiny-apps/tree/master/critvalues', target="_blank")),
br()
),
div(class="span3", strong('Sources of inspiration and code for learning Shiny'),
p(HTML('<ul>'),
HTML('<li>'),a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("Introducing R Shiny web apps", href="http://blog.snap.uaf.edu/2013/05/20/introducing-r-shiny-web-apps/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("R sampling app version 2", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-2/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("R sampling app version 3", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-3/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("R sampling app version 4", href="http://blog.snap.uaf.edu/2013/05/20/r-sampling-app-version-4/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("Mathematical notation in R plots", href="http://blog.snap.uaf.edu/2013/03/25/mathematical-notation-in-r-plots/", target="_blank"),HTML('</li>'),
HTML('<li>'),a("Mathematical notation in R plots 2", href="http://blog.snap.uaf.edu/2013/05/14/mathematical-notation-in-r-plots-2/", target="_blank"),HTML('</li>'),
HTML('</ul>')),
br()
)

)
}