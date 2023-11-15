import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import models, transforms, datasets
from torch.utils.data import DataLoader
import os

# Set the device to GPU if available, otherwise, use CPU
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Define data transformations
transform = transforms.Compose([
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# Define paths to your datasets
root_1 = '/Users/asamarka/paper/data/LAST/15c/'  # Update with the path to the first dataset
root_2 = '/Users/asamarka/paper/data/LAST/AF15/'  # Update with the path to the second dataset
root_3 = '/Users/asamarka/paper/data/LAST/eye15/'  # Update with the path to the third dataset

# Load pre-trained model (e.g., ResNet-18) and remove its classification layer
pretrained_model = models.resnet18(pretrained=True)
pretrained_model = nn.Sequential(*list(pretrained_model.children())[:-1])
pretrained_model.to(device)
pretrained_model.eval()

classifier = nn.Sequential(
    nn.Flatten(),
    nn.Linear(512, 256),
    nn.ReLU(),
    nn.Linear(256, 3)
).to(device)

# Initialize classifier weights with Xavier initialization
for layer in classifier.children():
    if isinstance(layer, nn.Linear):
        nn.init.xavier_uniform_(layer.weight)

# Use CrossEntropyLoss for multi-class classification
criterion = nn.CrossEntropyLoss()

# Use an optimizer with learning rate scheduling
optimizer = optim.Adam(classifier.parameters(), lr=0.001)
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.1)

# Define data loaders for all three datasets
dataset_1 = datasets.ImageFolder(os.path.join(root_1, 'train'), transform=transform)
dataset_2 = datasets.ImageFolder(os.path.join(root_2, 'train'), transform=transform)
dataset_3 = datasets.ImageFolder(os.path.join(root_3, 'train'), transform=transform)

data_loader_1 = DataLoader(dataset_1, batch_size=10, shuffle=True)
data_loader_2 = DataLoader(dataset_2, batch_size=10, shuffle=True)
data_loader_3 = DataLoader(dataset_3, batch_size=10, shuffle=True)

# Training loop
num_epochs = 10
for epoch in range(num_epochs):
    classifier.train()
    total_loss = 0
    total_correct = 0

    for data_loader in [data_loader_1, data_loader_2, data_loader_3]:
        for inputs, labels in data_loader:
            inputs, labels = inputs.to(device), labels.to(device)

            with torch.no_grad():
                features = pretrained_model(inputs)

            outputs = classifier(features)

            loss = criterion(outputs, labels)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            total_loss += loss.item()
            _, predictions = torch.max(outputs, 1)
            total_correct += torch.sum(predictions == labels)

    # Learning rate scheduling step
    scheduler.step()

    # Print training statistics
    print(f'Epoch [{epoch + 1}/{num_epochs}] - Loss: {total_loss / (len(dataset_1) + len(dataset_2) + len(dataset_3))}, Accuracy: {total_correct.item() / (len(dataset_1) + len(dataset_2) + len(dataset_3)) * 100:.2f}%')

print("Training complete")
