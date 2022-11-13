library(shiny)
library(data.table)
#library(shinydashboard)
library("shinydashboardPlus")
library(DT)
d=fread("../toinspect.csv.gz")

body=dashboardBody(fluidRow(
  box(width=2, height=600,
    actionButton("previous", "Previous sequence", icon=icon("backward", class="fa-2x"), width="100%"),
    actionButton("next", "Next sequence", icon=icon("forward", class="fa-2x"), width="100%"),
    hr(),
    actionButton("play", "Play sequence", icon=icon("play", class="fa-2x"), width="100%"),
    actionButton("plusone", "Next image in sequence", icon=icon("step-forward", class="fa-2x"), width="100%"),
    actionButton("plusone", "Previous image in sequence", icon=icon("step-backward", class="fa-2x"), width="100%"),
    actionButton("cut", "Split sequence after this image", icon=icon("scissors", class="fa-2x"), width="100%")
  ),
  box(width=8, height=600,
      imageOutput("photo")
    ),
    box(width=2,height=600,
    #column(1, id="nextcol", actionLink("next", "", icon=icon("forward", class="fa-3x"))),
    #column(2,
    selectInput("base", label = "File", choices = d$base),
    DTOutput("unchanged"),
    br(),
    accordion(
 id = "accordion1",
  accordionItem(
    title = "Accordion 1 Item 1",
    color = "danger",
    collapsed = TRUE,
    "This is some text!"
  ),
  accordionItem(
    title = "Accordion 1 Item 2",
    color = "warning",
    collapsed = FALSE,
    "This is some text!"
  )
),
# # accordion(
#  inputId = "accordion2",
#   accordionItem(
#     title = "Accordion 2 Item 1",
#     color = "danger",
#     collapsed = TRUE,
#     "This is some text!"
#   ),
#   accordionItem(
#     title = "Accordion 2 Item 2",
#     color = "warning",
#     collapsed = FALSE,
#     "This is some text!"
#   )
# )
br(),
    actionButton("is_empty", "Empty"),
    actionButton("savenext", "Save & Next")
  )

),
fluidRow(column(12,
  tableOutput("table")
)))

ui = dashboardPage(
  dashboardHeader(disable=T),
  dashboardSidebar(disable=T),
  body
)

server <- function(input, output, session) {
  #output$summary=renderText({input$base})
  output$unchanged=renderDT({
    extract=d[base == input$base,][1,]
    extract=t(extract[,c("Block", "Season" ,"CT_Number", "Cam_Type", "Team", "Researcher", "DateTime")])
    #names=rownames(extract)
    #extract=as.data.table(cbind(names, extract))
    #colnames(extract)=c("field", "value")
    colnames(extract)=c("value")
    datatable(extract, editable=T,  options = list(
    info = FALSE,
    paging = FALSE,
    searching = FALSE
  ))
  })
  output$photo=renderImage({
    list(
      src=basename(input$base), height="550")
  }, deleteFile=FALSE)
  output$table=renderTable({
    extract=d[base == input$base]
    toselect=unlist(extract[,lapply(.SD, function (x) length(unique(x))), .SDcols=-1])
    toselect=(1:length(toselect))[toselect>1]
    extract=extract[,-1]
    extract=extract[,..toselect]
    extract=t(extract)
    enms=rownames(extract)
    extract=as.data.table(extract)
    extract[,field:=..enms]
    extract
  })

}

shinyApp(ui, server)
