library(shiny)
library(DBI)
library(ggplot2)
library(plotly)

ui <- fluidPage(
    titlePanel("Análise de Dados de ISTs"),
    sidebarLayout(
        sidebarPanel(
            selectInput("doenca", "Selecione a Doença:", 
                        choices = c("Todas", "HIV", "Sífilis", "Gonorreia", "HPV")),
            sliderInput("idade", "Faixa Etária:", 
                        min = 18, max = 80, value = c(18, 60))
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Distribuição", plotlyOutput("distPlot")),
                tabPanel("Tendências", plotlyOutput("timePlot")),
                tabPanel("Tabela", DT::dataTableOutput("dataTable"))
            )
        )
    )
)

server <- function(input, output) {
    conn <- dbConnect(
        RMySQL::MySQL(),
        host = "192.168.56.20",
        user = "root",
        password = "senha123",
        dbname = "ist_data"
    )
    
    dados <- reactive({
        query <- "SELECT * FROM pacientes"
        if (input$doenca != "Todas") {
            query <- paste0(query, " WHERE doenca = '", input$doenca, "'")
        }
        query <- paste0(query, " AND idade BETWEEN ", input$idade[1], " AND ", input$idade[2])
        
        dbGetQuery(conn, query)
    })
    
    output$distPlot <- renderPlotly({
        df <- dados()
        ggplotly(
            ggplot(df, aes(x = idade, fill = doenca)) +
                geom_histogram(bins = 20) +
                labs(title = "Distribuição por Idade") +
                theme_minimal()
        )
    })
    
    output$timePlot <- renderPlotly({
        df <- dados()
        df$mes <- format(as.Date(df$data_teste), "%Y-%m")
        
        ggplotly(
            df %>% 
                count(mes, doenca) %>%
                ggplot(aes(x = mes, y = n, color = doenca, group = doenca)) +
                geom_line() +
                labs(title = "Casos por Mês", x = "Mês", y = "Número de Casos") +
                theme_minimal()
        )
    })
    
    output$dataTable <- DT::renderDataTable({
        dados()
    })
    
    onStop(function() {
        dbDisconnect(conn)
    })
}

shinyApp(ui, server)