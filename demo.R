library(shiny)
library(ShinyEditor)

# UI
ui <- fluidPage(

  # Setup
  use_editor("API-Key"),
  titlePanel("HTML Generator"),

  # Text Input 1
  fluidRow(

      width = 12,
      editor('textcontent', text = test$mytext,
             options = "branding: false,
             height: 300,
             plugins: ['lists', 'table', 'link', 'image', 'code'],
             toolbar1: 'bold italic forecolor backcolor | formatselect fontselect fontsizeselect | alignleft aligncenter alignright alignjustify',
            toolbar2: 'undo redo removeformat bullist numlist table blockquote code superscript  subscript strikethrough link image',
              paste_data_images: true"),
      br(),
      actionButton(
        "generatehtml",
        "Generate HTML Code",
        icon = icon("code"),
        class = "btn-primary"
      ),

      downloadButton(
        "downloadhtml",
        "Generate HTML file"),
actionButton(
  "savehtml",
  "Save Input"),

    column(
      width = 6,
      tags$pre(textOutput("rawText"))
    )
  )

)

# Server
server <- function(input, output, session) {

  # Generate HTML
  observeEvent(input$generatehtml, {

    editorText(session, editorid = 'textcontent', outputid = 'mytext')

    output$rawText <- renderText({
      req(input$mytext)
      enc2utf8(input$mytext)
    })

  })

  observeEvent(input$savehtml,{

    outputList <- reactiveValuesToList(input)

    saveRDS(outputList,file = "rdata/test.RData")

  })

  output$downloadhtml <- downloadHandler(
    filename = function(){
      paste0("4F Research note ", input$selectedCompany, ".html")
    },
    content = function(file) {

      outputList <- reactiveValuesToList(input)

     print(outputList)

      rmarkdown::render(input       = "demo.Rmd",
                        output_file = file,
                        params      = outputList["mytext"])



    }
  )

}

# Run App
shinyApp(ui = ui, server = server)
