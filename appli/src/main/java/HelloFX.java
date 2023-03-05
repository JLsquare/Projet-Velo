import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.RowConstraints;
import javafx.stage.Stage;
import javafx.scene.control.ScrollPane;

public class HelloFX extends Application {
    /**
     * Entry point for our JavaFX application.
     * 
     * @param stage the primary stage for this application, onto which the
     *              application scene can be set.
     */
    @Override
    public void start(Stage stage) {
        GridPane grid = createGrid();
        generateSideBar(grid);

        Scene scene = new Scene(grid, 800, 600);
        stage.setMinWidth(800);
        stage.setMinHeight(600);

        stage.setScene(scene);
        stage.show();
    }

    /**
     * Creates a GridPane for our application
     * Currently 2x2
     * 
     * @return The main grid for our application
     */
    static GridPane createGrid() {
        /*
         * First column is 300px wide, and doesn't grow
         * Second column is 500px wide, and grows
         * First row is 500px tall, and grows
         * Second row is 100px tall, and doesn't grow
         */

        GridPane grid = new GridPane();
        grid.setGridLinesVisible(true);

        ColumnConstraints col1 = new ColumnConstraints();
        col1.setHgrow(Priority.NEVER);
        col1.setMinWidth(300);
        grid.getColumnConstraints().add(col1);

        ColumnConstraints col2 = new ColumnConstraints();
        col2.setHgrow(Priority.ALWAYS);
        col2.setMinWidth(500);
        grid.getColumnConstraints().add(col2);

        RowConstraints row1 = new RowConstraints();
        row1.setVgrow(Priority.ALWAYS);
        row1.setMinHeight(500);
        grid.getRowConstraints().add(row1);

        RowConstraints row2 = new RowConstraints();
        row2.setVgrow(Priority.NEVER);
        row2.setMinHeight(100);
        grid.getRowConstraints().add(row2);

        return grid;
    }

    /**
     * Generates a scrollable sidebar for our application
     * 
     * @param grid the grid, as created by createGrid()
     */
    static void generateSideBar(GridPane grid) {
        ScrollPane scrollPane = new ScrollPane();

        scrollPane.setVbarPolicy(ScrollPane.ScrollBarPolicy.AS_NEEDED);
        scrollPane.setHbarPolicy(ScrollPane.ScrollBarPolicy.NEVER);

        // Make it so the sidebar is always as it's container allows
        scrollPane.setFitToWidth(true);

        // The sidebar's contents (just many rows)
        GridPane sidebar = new GridPane();
        sidebar.setGridLinesVisible(true);

        // TODO: Add actual content instead of placeholders
        for (int i = 0; i < 100; i++) {
            Button button = new Button("Button " + i);

            // Buttons must occupy the entire width
            button.setMaxWidth(Double.MAX_VALUE);
            GridPane.setHgrow(button, Priority.ALWAYS);

            sidebar.add(button, 0, i);
        }

        scrollPane.setContent(sidebar);
        grid.add(scrollPane, 0, 0);
    }

    /**
     * Entry point for our application
     * 
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        launch();
    }
}