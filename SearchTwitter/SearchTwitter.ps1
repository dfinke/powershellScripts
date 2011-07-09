Import-Module showui

function Search-Twitter {
    param ( 
        [Parameter(ValueFromPipeline=$true)]
        $query
    )
    
    Begin { $wc = New-Object Net.Webclient }
    
    Process {
        $url = "http://search.twitter.com/search.rss?q=$query"
        ([xml]$wc.downloadstring($url)).rss.channel.item |
            Select *
    }
}

function New-TwitterFeed ($search) {

    $guid = "g" + [guid]::NewGuid() -replace "-",""
    
    $buttonAttributes = @{
        Margin = 5
        HorizontalAlignment = "Right"
        Height = 25 
        Tag = $guid 
    }
    
    $labelAttributes = @{
        FontSize = 20 
        Margin = 5 
        Foreground = "White"
    }
    
    Grid -Name $guid -Rows 45, 100* -Tag $search {
        Grid -Row 0 -Columns 2 {            
            Label -Column 0 $Search @labelAttributes
            Button " X " -Column 1 @buttonAttributes -On_Click {
                $name = "`$$($this.tag)"
                $targetLayout.Children.Remove(($name|iex))                
            }
        }
        
        ListBox -Background Black -Row 1 -Margin 5 -DataContext {
            Search-Twitter $search
        } -DataBinding @{
            ItemsSource="."
        } -ItemTemplate {
            $tweetTbAttributes = @{
                FontSize = 12
                Margin = 5 
                TextWrapping = "wrap"
                Foreground = "White"
            }
                      
            Grid -Columns 55, 300 {
                Image     -Name Image  -Column 0 -Margin 6
                TextBlock -Name Title @tweetTbAttributes -Column 1 
            } | ConvertTo-DataTemplate -binding @{
                "Image.Source" = "image_link"
                "Title.Text" = "title"
            }
        }
    }
}

function ql {$args}

$windowAttributes = @{
    WindowStartupLocation = "CenterScreen"
    Width = 1200
    Height = 600
    Background = "Black"
    Title = "PowerShell, ShowUI and the Twitter API"
}

$scrollViewerAttributes = @{
    VerticalScrollBarVisibility = "Disabled"
    HorizontalScrollBarVisibility = "Auto"
}

$textBboxAttributes = @{
    Margin = 5 
    Background = "DarkGray "
    Foreground = "#FFFFFF" 
    FontSize = 14
}

New-Window  @ws  -Show -On_Loaded {
    $search.focus()
    ql PowerShell ShowUI dfinke jamesbru  jaykul | 
        ForEach { 
            $targetLayout.Children.Add( (New-TwitterFeed $_ $tabcontrol) ) 
        }
} {
    Grid -Columns 35*, 75 -Rows 35, 100* {

        TextBox -Name Search -Row 0 -Column 0 @textBboxAttributes

        Button -IsDefault -Row 0 -Column 1 -Margin 5 "_Search" -On_Click {            
            $targetLayout.Children.Add( (New-TwitterFeed $Search.Text) )
            $Search.Text = ""
        }

        ScrollViewer -Row 1 -Column 0 -ColumnSpan 2 @scrollViewerAttributes {
            UniformGrid -Name targetLayout -Rows 1
        }
    }
}