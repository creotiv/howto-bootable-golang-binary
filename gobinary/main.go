package main

import (
	"fmt"
)

func main() {
    var data string
    fmt.Println("Hello from your Go image!")
    for {
	fmt.Println("Enter something:")
    	fmt.Scanln(&data)
	fmt.Printf("Echo: %s\n", data)
    }
}
