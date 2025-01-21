# SwiftUI User List

<img width="300" alt="User List App" src="https://github.com/OpenClassrooms-Student-Center/DA-iOS_P4_exercise-2/assets/10169030/026e4b94-84d7-4d07-a07b-ab30654dea80">


## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)

### Introduction

The SwiftUI User List is a modern iOS application built with SwiftUI. It provides users with the ability to view a list of users and their details. This README will guide you through the app's features, how to get started, and its underlying MVVM architecture.

### Features

- **User List**: View a list of users with their names and profile pictures.
- **User Details**: Select a user from the list to view their detailed information, including their name and date of birth.
- **Format selection**: You can choose between list and grid display.
- **Reload data**: You can reload the displayed data.
- **Infinite scroll**: You can scroll down infinitely.

### Todo

- **Extract logic to a viewModel**: The main view contains to much logic, you should extract it to a viewModel, and unit test it.
- **Extract view components from main view**: The main view contains to much view logic, you should split it in several sub view components.

### MVVM Architecture (Model - View - ViewModel)

##### View
Responsible of managing the view state. No data/data-logic is handled here.

##### ViewModel
This is where the magic happens. This layer is listening for events from above through Inputs and transform them to Outputs. Thanks to this separation, each layer can communicates with each others without having a tight coupling of responsabilities.

##### Repository (Model)
Responsible of providing Data, by hiding where it comes from. In this project it's basicaly provided by `FileManager` but it could be either from Network etc..

## Getting Started

### Prerequisites

- Xcode 14 or later.
- iOS 16 or later.

### Installation

1. Clone the repository to your local machine:
```shell
git clone https://github.com/OpenClassrooms-Student-Center/DA-iOS_P4_exercise-2.git
```
2. Open the project in Xcode.
3. Build and run the project on your preferred simulator or physical device.

### Usage

Launch the app and play with it 💪


