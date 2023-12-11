using System.Diagnostics;

namespace Day11;

class Program
{
    static void Main(string[] args)
    {
        // Source of the Grid class: https://github.com/z1c0/aoc
        var grid = Input.ReadCharGrid("input.txt");
        
        // Replace every row that only contains '.' with two rows of '.'
        var expandedRows = grid.FindRows('.').ToList();
        int lastExpandedRowIndex = expandedRows.FirstOrDefault();
        while (expandedRows.Count > 0) {
            grid = grid.InsertRow(lastExpandedRowIndex, '.');
            expandedRows = grid.FindRows('.').Where(r => r > lastExpandedRowIndex + 1).ToList();
            lastExpandedRowIndex = expandedRows.FirstOrDefault();
        }

        // Replace every column that only contains '.' with two columns of '.'
        var expandedColumns = grid.FindColumns('.').ToList();
        int lastExpandedColumnIndex = expandedColumns.FirstOrDefault();
        while (expandedColumns.Count > 0) {
            grid = grid.InsertColumn(lastExpandedColumnIndex, '.');
            expandedColumns = grid.FindColumns('.').Where(c => c > lastExpandedColumnIndex + 1).ToList();
            lastExpandedColumnIndex = expandedColumns.FirstOrDefault();
        }
        // Give a unique number to every "#" in the grid
        // Calculate the distance between all possible pairs of "#"s, but the pairs should be unique
        // The distance between two "#"s is the Manhattan distance between their coordinates
        // The answer is the minimum distance between two "#"s
        var distances = new List<int>();
        var hashes = grid.FindAll('#').ToList();
        foreach (var hash in hashes)
        {
            for (var i = 0; i < hashes.Count; i++)
            {
                if (hashes[i] != hash)
                {
                    var distance = Math.Abs(hash.X - hashes[i].X) + Math.Abs(hash.Y - hashes[i].Y);
                    distances.Add(distance);
                }
            }
        }

        // sum the distances and divide by 2 because we counted every pair twice
        // Print the answer
        Console.WriteLine(distances.Sum() / 2);
    }
}
