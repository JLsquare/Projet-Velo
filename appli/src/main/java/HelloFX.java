import javafx.application.Application;
import javafx.geometry.HPos;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.RowConstraints;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

public class HelloFX extends Application {
    static int counter;

    @Override
    public void start(Stage stage) {
        GridPane grid = createGrid();

        Scene scene = new Scene(grid, 800, 600);
        stage.setMinWidth(800);
        stage.setMinHeight(600);

        stage.setScene(scene);
        stage.show();
    }

    static GridPane createGrid() {
        GridPane grid = new GridPane();
        grid.setGridLinesVisible(true);

        grid.setHgap(10);
        grid.setVgap(10);

        // Set column constraints
        ColumnConstraints col1 = new ColumnConstraints();
        col1.setHgrow(Priority.ALWAYS); // Always grow horizontally if possible
        col1.setMinWidth(120);

        return grid;
    }

    public static void main(String[] args) {
        counter = 0;

        launch();
    }
}