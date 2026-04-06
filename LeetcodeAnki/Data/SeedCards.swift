import Foundation

// MARK: - SeedCards
/// Static seed data. All 30+ real LeetCode problems with problem statements,
/// hints, and solution approach explanations.
enum SeedCards {
    static let all: [Card] = [

        // MARK: Arrays

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            title: "Two Sum",
            category: .arrays,
            difficulty: .easy,
            problem: """
            Given an array of integers `nums` and an integer `target`, return the indices \
            of the two numbers such that they add up to `target`. You may assume that each \
            input has exactly one solution, and you may not use the same element twice. \
            Return the answer in any order.

            Example:
              Input:  nums = [2, 7, 11, 15], target = 9
              Output: [0, 1]
            """,
            hint: """
            Think about what complement you need for each number. \
            A hash map lets you look up complements in O(1).
            """,
            solution: """
            Pattern: Hash Map (One Pass)

            1. Create an empty dictionary mapping value → index.
            2. For each number nums[i], compute complement = target - nums[i].
            3. If complement exists in the map, return [map[complement], i].
            4. Otherwise store nums[i] → i in the map.

            Time: O(n) | Space: O(n)

            Key insight: Instead of a nested loop (O(n²)), trade space for time \
            using a hash map to find the complement in constant time.
            """,
            leetcodeURL: "https://leetcode.com/problems/two-sum/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            title: "Three Sum",
            category: .arrays,
            difficulty: .medium,
            problem: """
            Given an integer array `nums`, return all the triplets [nums[i], nums[j], nums[k]] \
            such that i ≠ j, i ≠ k, j ≠ k, and nums[i] + nums[j] + nums[k] == 0. \
            The solution set must not contain duplicate triplets.

            Example:
              Input:  nums = [-1, 0, 1, 2, -1, -4]
              Output: [[-1, -1, 2], [-1, 0, 1]]
            """,
            hint: """
            Sort the array first. Fix one element, then use two pointers to \
            find pairs that sum to its negation. Skip duplicates carefully.
            """,
            solution: """
            Pattern: Sort + Two Pointers

            1. Sort nums.
            2. For each index i (skip duplicates), set lo = i+1, hi = len-1.
            3. While lo < hi:
               - If sum == 0: add triplet, advance both pointers (skip dupes).
               - If sum < 0: lo++
               - If sum > 0: hi--

            Time: O(n²) | Space: O(1) ignoring output

            Key insight: Sorting + two-pointer avoids the O(n³) brute-force. \
            Deduplication is handled by skipping repeated values for the outer \
            and inner pointers.
            """,
            leetcodeURL: "https://leetcode.com/problems/3sum/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            title: "Maximum Subarray (Kadane's)",
            category: .arrays,
            difficulty: .medium,
            problem: """
            Given an integer array `nums`, find the subarray with the largest sum, \
            and return its sum.

            Example:
              Input:  nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
              Output: 6  (subarray [4, -1, 2, 1])
            """,
            hint: """
            At each element, decide: extend the current subarray or start a new \
            one? Keep a running sum and a global max.
            """,
            solution: """
            Pattern: Kadane's Algorithm (Dynamic Programming)

            1. currentSum = nums[0], maxSum = nums[0]
            2. For i from 1 to n-1:
               currentSum = max(nums[i], currentSum + nums[i])
               maxSum = max(maxSum, currentSum)
            3. Return maxSum.

            Time: O(n) | Space: O(1)

            Key insight: If currentSum + nums[i] < nums[i], the previous subarray \
            is dragging us down — restart from nums[i]. This greedy choice is \
            optimal because a negative prefix never helps the sum.
            """,
            leetcodeURL: "https://leetcode.com/problems/maximum-subarray/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
            title: "Trapping Rain Water",
            category: .arrays,
            difficulty: .hard,
            problem: """
            Given `n` non-negative integers representing an elevation map where each bar \
            has width 1, compute how much water it can trap after raining.

            Example:
              Input:  height = [0,1,0,2,1,0,1,3,2,1,2,1]
              Output: 6
            """,
            hint: """
            Water at index i is bounded by min(maxLeft[i], maxRight[i]) - height[i]. \
            Use two pointers to avoid extra space.
            """,
            solution: """
            Pattern: Two Pointers

            1. lo = 0, hi = n-1, leftMax = 0, rightMax = 0, water = 0
            2. While lo <= hi:
               - If height[lo] <= height[hi]:
                   leftMax = max(leftMax, height[lo])
                   water += leftMax - height[lo]
                   lo++
               - Else:
                   rightMax = max(rightMax, height[hi])
                   water += rightMax - height[hi]
                   hi--
            3. Return water.

            Time: O(n) | Space: O(1)

            Key insight: The limiting factor is always the shorter side. \
            By moving the pointer from the shorter side inward, we can calculate \
            trapped water without precomputing prefix/suffix max arrays.
            """,
            leetcodeURL: "https://leetcode.com/problems/trapping-rain-water/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
            title: "Merge Intervals",
            category: .arrays,
            difficulty: .medium,
            problem: """
            Given an array of `intervals` where intervals[i] = [start_i, end_i], merge all \
            overlapping intervals, and return an array of the non-overlapping intervals.

            Example:
              Input:  intervals = [[1,3],[2,6],[8,10],[15,18]]
              Output: [[1,6],[8,10],[15,18]]
            """,
            hint: """
            Sort by start time. Iterate and merge when the current interval's start \
            is ≤ the last merged interval's end.
            """,
            solution: """
            Pattern: Sort + Linear Scan

            1. Sort intervals by start time.
            2. Initialize result with the first interval.
            3. For each subsequent interval:
               - If current.start <= result.last.end: extend result.last.end = max(...)
               - Else: append current to result.
            4. Return result.

            Time: O(n log n) | Space: O(n)

            Key insight: After sorting, overlapping intervals are always adjacent, \
            so a single linear pass is sufficient to merge them.
            """,
            leetcodeURL: "https://leetcode.com/problems/merge-intervals/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
            title: "Meeting Rooms II",
            category: .arrays,
            difficulty: .medium,
            problem: """
            Given an array of meeting time `intervals` where intervals[i] = [start_i, end_i], \
            return the minimum number of conference rooms required.

            Example:
              Input:  intervals = [[0,30],[5,10],[15,20]]
              Output: 2
            """,
            hint: """
            Separate start and end times, sort them independently, then use \
            a two-pointer sweep to count concurrent meetings.
            """,
            solution: """
            Pattern: Two sorted arrays (Chronological Ordering)

            1. Sort start times and end times separately.
            2. Use pointers s=0, e=0, rooms=0, maxRooms=0.
            3. While s < n:
               - If starts[s] < ends[e]: rooms++, s++
               - Else: rooms--, e++
               maxRooms = max(maxRooms, rooms)
            4. Return maxRooms.

            Alternative: Min-Heap of end times (O(n log n) but more intuitive).

            Time: O(n log n) | Space: O(n)

            Key insight: A new room is needed whenever a meeting starts before \
            any existing meeting ends. The sweep line approach counts rooms \
            without simulating individual allocations.
            """,
            leetcodeURL: "https://leetcode.com/problems/meeting-rooms-ii/"
        ),

        // MARK: Linked List

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
            title: "Merge Two Sorted Lists",
            category: .linkedList,
            difficulty: .easy,
            problem: """
            You are given the heads of two sorted linked lists `list1` and `list2`. \
            Merge the two lists into one sorted list. The list should be made by splicing \
            together the nodes of the first two lists. Return the head of the merged list.

            Example:
              Input:  list1 = 1→2→4,  list2 = 1→3→4
              Output: 1→1→2→3→4→4
            """,
            hint: """
            Use a dummy head node. Advance through both lists, always attaching \
            the smaller node. Attach the remaining tail when one list is exhausted.
            """,
            solution: """
            Pattern: Dummy Head + Two Pointers

            1. Create a dummy sentinel node; curr = dummy.
            2. While both lists are non-nil:
               - Compare list1.val and list2.val.
               - Attach the smaller, advance that list pointer.
               - Advance curr.
            3. Attach the remaining non-nil list to curr.next.
            4. Return dummy.next.

            Time: O(m + n) | Space: O(1)

            Key insight: The dummy node eliminates edge cases for the head of \
            the result list, keeping the loop body clean.
            """,
            leetcodeURL: "https://leetcode.com/problems/merge-two-sorted-lists/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
            title: "Reverse Nodes in K-Group",
            category: .linkedList,
            difficulty: .hard,
            problem: """
            Given the head of a linked list, reverse the nodes of the list `k` at a time, \
            and return the modified list. If the number of nodes is not a multiple of k then \
            left-out nodes, in the end, should remain as is.

            Example:
              Input:  head = 1→2→3→4→5, k = 2
              Output: 2→1→4→3→5
            """,
            hint: """
            Check that at least k nodes remain before reversing. Keep track of \
            the tail of the previous reversed group to connect groups together.
            """,
            solution: """
            Pattern: Iterative Group Reversal

            1. Count if k nodes exist from current position; if not, stop.
            2. Reverse k nodes (standard reversal), capturing new head and tail.
            3. Connect prevGroupTail → newHead, newTail → nextGroupHead.
            4. Advance to next group and repeat.

            Time: O(n) | Space: O(1)

            Key insight: Treat each group of k as an independent reversal subproblem. \
            Maintaining pointers to the tail of the previous group and the head of \
            the next group is the crux of correctly chaining groups together.
            """,
            leetcodeURL: "https://leetcode.com/problems/reverse-nodes-in-k-group/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
            title: "Linked List Cycle II",
            category: .linkedList,
            difficulty: .medium,
            problem: """
            Given the head of a linked list, return the node where the cycle begins. \
            If there is no cycle, return null. Do not modify the list.

            Example:
              Input:  head = [3,2,0,-4] with tail connecting to node index 1
              Output: node with value 2
            """,
            hint: """
            Use Floyd's algorithm: fast/slow pointers meet inside the cycle. \
            Then reset one pointer to head and advance both by 1 — they meet at the cycle entry.
            """,
            solution: """
            Pattern: Floyd's Cycle Detection (Tortoise & Hare)

            Phase 1 — Detect cycle:
              slow and fast both start at head.
              Move slow by 1, fast by 2. If they meet, a cycle exists.

            Phase 2 — Find entry point:
              Reset one pointer to head. Move both pointers by 1 each step.
              They meet at the cycle start node.

            Mathematical proof: If the cycle starts k steps from head and the \
            meeting point is m steps into the cycle, then k ≡ cycle_length - m.

            Time: O(n) | Space: O(1)
            """,
            leetcodeURL: "https://leetcode.com/problems/linked-list-cycle-ii/"
        ),

        // MARK: Trees & Graphs

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
            title: "Number of Islands",
            category: .treesGraphs,
            difficulty: .medium,
            problem: """
            Given an m×n 2D binary grid `grid` which represents a map of '1's (land) and \
            '0's (water), return the number of islands. An island is surrounded by water and \
            is formed by connecting adjacent lands horizontally or vertically.

            Example:
              Input:  grid = [["1","1","0","0","0"],["1","1","0","0","0"],
                               ["0","0","1","0","0"],["0","0","0","1","1"]]
              Output: 3
            """,
            hint: """
            Iterate the grid. When you find a '1', increment count and BFS/DFS \
            to mark the entire connected island as visited (change '1' to '0').
            """,
            solution: """
            Pattern: DFS/BFS Flood Fill

            1. Scan every cell.
            2. On finding '1': increment islands, run DFS/BFS from that cell.
            3. DFS: mark cell as '0', recurse on 4 neighbors that are '1'.
            4. Return islands.

            Time: O(m × n) | Space: O(m × n) for recursion stack

            Key insight: The DFS marks each land cell as visited in-place, \
            so we avoid a separate visited array. Each cell is processed at most once.
            """,
            leetcodeURL: "https://leetcode.com/problems/number-of-islands/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000011")!,
            title: "Clone Graph",
            category: .treesGraphs,
            difficulty: .medium,
            problem: """
            Given a reference of a node in a connected undirected graph, return a deep copy \
            (clone) of the graph. Each node contains a value (int) and a list of its neighbors.

            Example:
              Input:  adjacency list [[2,4],[1,3],[2,4],[1,3]]
              Output: cloned adjacency list [[2,4],[1,3],[2,4],[1,3]]
            """,
            hint: """
            Use a hash map from original node → cloned node. DFS or BFS: \
            clone each node when first seen and recursively clone its neighbors.
            """,
            solution: """
            Pattern: DFS + HashMap (visited map)

            1. If node is nil, return nil.
            2. If node already in visited map, return cloned node.
            3. Create clone = Node(node.val).
            4. Add to visited map: visited[node] = clone.
            5. For each neighbor, recursively clone and add to clone.neighbors.
            6. Return clone.

            Time: O(V + E) | Space: O(V)

            Key insight: The visited map serves double duty — it prevents infinite \
            loops on cycles AND maps original nodes to their clones for connecting \
            neighbor references.
            """,
            leetcodeURL: "https://leetcode.com/problems/clone-graph/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000012")!,
            title: "Word Ladder",
            category: .treesGraphs,
            difficulty: .hard,
            problem: """
            A transformation sequence from word `beginWord` to word `endWord` using a \
            dictionary `wordList` is a sequence where every adjacent pair of words differs \
            by a single letter and every word in the sequence is in wordList. \
            Return the number of words in the shortest transformation sequence, or 0 if none.

            Example:
              Input:  beginWord = "hit", endWord = "cog",
                      wordList = ["hot","dot","dog","lot","log","cog"]
              Output: 5  ("hit"→"hot"→"dot"→"dog"→"cog")
            """,
            hint: """
            Model as a graph: each word is a node, edges connect words differing by 1 letter. \
            BFS from beginWord gives the shortest path. Use bidirectional BFS to speed up.
            """,
            solution: """
            Pattern: BFS (Shortest Path in Unweighted Graph)

            1. Put wordList into a set for O(1) lookup.
            2. BFS queue: [(beginWord, level=1)].
            3. For each word, generate all neighbors by replacing each char with a-z.
            4. If neighbor == endWord: return level + 1.
            5. If neighbor is in the word set, add to queue, remove from set.
            6. Return 0 if queue empties.

            Time: O(M² × N) where M = word length, N = wordList size | Space: O(M² × N)

            Key insight: BFS guarantees the shortest path. Removing visited words \
            from the set avoids revisiting. Generating neighbors character-by-character \
            avoids building an explicit adjacency list.
            """,
            leetcodeURL: "https://leetcode.com/problems/word-ladder/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000013")!,
            title: "Binary Tree Level Order Traversal",
            category: .treesGraphs,
            difficulty: .medium,
            problem: """
            Given the root of a binary tree, return the level order traversal of its nodes' \
            values (i.e., from left to right, level by level).

            Example:
              Input:  root = [3,9,20,null,null,15,7]
              Output: [[3],[9,20],[15,7]]
            """,
            hint: """
            BFS with a queue. Process all nodes at the current level before \
            moving to the next. Track level boundaries using queue size.
            """,
            solution: """
            Pattern: BFS with level tracking

            1. If root is nil, return [].
            2. queue = [root], result = [].
            3. While queue not empty:
               levelSize = queue.count
               currentLevel = []
               For i in 0..<levelSize:
                 node = queue.dequeue()
                 currentLevel.append(node.val)
                 if node.left: queue.enqueue(node.left)
                 if node.right: queue.enqueue(node.right)
               result.append(currentLevel)
            4. Return result.

            Time: O(n) | Space: O(n)

            Key insight: Capturing queue.count at the start of each iteration \
            cleanly separates levels without needing level markers in the queue.
            """,
            leetcodeURL: "https://leetcode.com/problems/binary-tree-level-order-traversal/"
        ),

        // MARK: Stacks & Strings

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000014")!,
            title: "Min Stack",
            category: .stacksStrings,
            difficulty: .easy,
            problem: """
            Design a stack that supports push, pop, top, and retrieving the minimum element \
            in constant time. Implement MinStack with: push(val), pop(), top(), getMin().

            Example:
              MinStack minStack = new MinStack();
              minStack.push(-2); minStack.push(0); minStack.push(-3);
              minStack.getMin(); → -3
              minStack.pop();
              minStack.getMin(); → -2
            """,
            hint: """
            Maintain a secondary 'min stack' alongside the main stack. Push to \
            the min stack only when the new value is ≤ current minimum.
            """,
            solution: """
            Pattern: Auxiliary Min Stack

            1. Two stacks: mainStack and minStack.
            2. push(val):
               - mainStack.push(val)
               - if minStack empty or val <= minStack.top(): minStack.push(val)
            3. pop():
               - if mainStack.top() == minStack.top(): minStack.pop()
               - mainStack.pop()
            4. top(): return mainStack.top()
            5. getMin(): return minStack.top()

            Time: O(1) all operations | Space: O(n)

            Key insight: The minStack only stores values that were the minimum \
            at the time of pushing, so it tracks the minimum at each historical \
            state of the main stack.
            """,
            leetcodeURL: "https://leetcode.com/problems/min-stack/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000015")!,
            title: "Decode String",
            category: .stacksStrings,
            difficulty: .medium,
            problem: """
            Given an encoded string, return its decoded string. The encoding rule is: \
            k[encoded_string], where the encoded_string inside the brackets is repeated \
            exactly k times.

            Example:
              Input:  s = "3[a2[c]]"
              Output: "accaccacc"
            """,
            hint: """
            Use a stack to track the current count and the string built before \
            each '['. On ']', pop and repeat.
            """,
            solution: """
            Pattern: Stack-based parsing

            1. stack stores (count, stringSoFar) pairs; currentStr = "", currentNum = 0.
            2. For each char c:
               - Digit: currentNum = currentNum * 10 + digit
               - '[': push (currentNum, currentStr); reset both
               - ']': (k, prev) = stack.pop(); currentStr = prev + currentStr * k
               - Letter: currentStr += c
            3. Return currentStr.

            Time: O(maxK^depth * n) | Space: O(n)

            Key insight: Every time we open a bracket we save state on the stack. \
            Closing a bracket multiplies and restores — naturally handles nesting.
            """,
            leetcodeURL: "https://leetcode.com/problems/decode-string/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000016")!,
            title: "Generate Parentheses",
            category: .stacksStrings,
            difficulty: .medium,
            problem: """
            Given n pairs of parentheses, write a function to generate all combinations \
            of well-formed parentheses.

            Example:
              Input:  n = 3
              Output: ["((()))","(()())","(())()","()(())","()()()"]
            """,
            hint: """
            Backtracking: only add '(' if open count < n; only add ')' if close < open. \
            This ensures all generated strings are valid.
            """,
            solution: """
            Pattern: Backtracking / DFS

            1. Recursive helper(current, open, close):
               - If len(current) == 2*n: add to result.
               - If open < n: recurse with current + '(', open+1, close.
               - If close < open: recurse with current + ')', open, close+1.
            2. Call helper("", 0, 0).

            Time: O(4^n / √n) — Catalan number | Space: O(n)

            Key insight: The invariant "close ≤ open ≤ n" is sufficient to \
            guarantee validity. No need to validate strings after generation.
            """,
            leetcodeURL: "https://leetcode.com/problems/generate-parentheses/"
        ),

        // MARK: Sorting & Searching

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000017")!,
            title: "Search in Rotated Sorted Array",
            category: .sorting,
            difficulty: .medium,
            problem: """
            There is an integer array `nums` sorted in ascending order (with distinct values). \
            Prior to being passed to your function, nums is possibly rotated at an unknown \
            pivot index k. Given the array nums and an integer target, return the index of \
            target if it is in nums, or -1 if it is not.

            Example:
              Input:  nums = [4,5,6,7,0,1,2], target = 0
              Output: 4
            """,
            hint: """
            Binary search still works. At each step, one half of the array is \
            guaranteed to be sorted — determine which half and check if target \
            falls in it to decide where to search.
            """,
            solution: """
            Pattern: Modified Binary Search

            1. lo = 0, hi = n-1.
            2. While lo <= hi:
               mid = (lo+hi)/2
               If nums[mid] == target: return mid.
               If nums[lo] <= nums[mid]:  // left half sorted
                 If nums[lo] <= target < nums[mid]: hi = mid-1
                 Else: lo = mid+1
               Else:  // right half sorted
                 If nums[mid] < target <= nums[hi]: lo = mid+1
                 Else: hi = mid-1
            3. Return -1.

            Time: O(log n) | Space: O(1)

            Key insight: At least one half of a rotated sorted array is always \
            fully sorted. Use that to determine which half to search.
            """,
            leetcodeURL: "https://leetcode.com/problems/search-in-rotated-sorted-array/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000018")!,
            title: "Merge K Sorted Lists",
            category: .sorting,
            difficulty: .hard,
            problem: """
            You are given an array of k linked-lists lists, each linked-list is sorted in \
            ascending order. Merge all the linked-lists into one sorted linked-list and return it.

            Example:
              Input:  lists = [[1,4,5],[1,3,4],[2,6]]
              Output: 1→1→2→3→4→4→5→6
            """,
            hint: """
            Use a min-heap of size k to always extract the globally smallest node. \
            Or use divide-and-conquer: merge pairs of lists recursively.
            """,
            solution: """
            Pattern: Min-Heap (Priority Queue)

            1. Push the head of each non-nil list into a min-heap keyed by node value.
            2. While heap not empty:
               - Extract minimum node, append to result.
               - If node.next exists, push node.next into heap.
            3. Return dummy.next.

            Time: O(N log k) where N = total nodes, k = number of lists.
            Space: O(k) for the heap.

            Alternative: Divide & Conquer — merge pairs of lists, recurse.
            Same O(N log k) time but O(log k) space.

            Key insight: The heap always holds exactly k candidates (one per remaining list), \
            so extracting the minimum is O(log k) not O(k).
            """,
            leetcodeURL: "https://leetcode.com/problems/merge-k-sorted-lists/"
        ),

        // MARK: DP & Math

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000019")!,
            title: "N-Queens",
            category: .dpMath,
            difficulty: .hard,
            problem: """
            The n-queens puzzle is the problem of placing n queens on an n×n chessboard such \
            that no two queens attack each other. Given an integer n, return all distinct \
            solutions to the n-queens puzzle.

            Example:
              Input:  n = 4
              Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]
            """,
            hint: """
            Backtracking: place one queen per row. Track which columns and diagonals \
            are occupied using sets. Prune early when a placement is invalid.
            """,
            solution: """
            Pattern: Backtracking with constraint sets

            1. Track: cols, diag1 (row-col), diag2 (row+col) as sets.
            2. For each row, try each column:
               - If col, diag1, diag2 not in occupied sets: place queen.
               - Add to all three sets, recurse to next row.
               - On backtrack, remove from sets.
            3. When row == n: record board state as a solution.

            Time: O(n!) | Space: O(n²)

            Key insight: Using three sets (column, two diagonals) allows O(1) \
            conflict checking. Both diagonals of a cell share a constant value \
            (r-c and r+c respectively) regardless of position.
            """,
            leetcodeURL: "https://leetcode.com/problems/n-queens/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000020")!,
            title: "Coin Change",
            category: .dpMath,
            difficulty: .medium,
            problem: """
            You are given an integer array `coins` representing coins of different denominations \
            and an integer `amount`. Return the fewest number of coins that you need to make up \
            that amount. If that amount cannot be made up, return -1.

            Example:
              Input:  coins = [1,5,11], amount = 15
              Output: 3  (5+5+5 or 1+1+11+... wait: 11+1+1+1+1 = 5 coins; but 5+5+5 = 3)
            """,
            hint: """
            Bottom-up DP: dp[i] = minimum coins to make amount i. \
            For each amount, try all coins and take the best.
            """,
            solution: """
            Pattern: Bottom-Up Dynamic Programming (Unbounded Knapsack variant)

            1. dp = array of size (amount+1) initialized to infinity.
            2. dp[0] = 0.
            3. For i from 1 to amount:
               For each coin:
                 If coin <= i: dp[i] = min(dp[i], dp[i - coin] + 1)
            4. Return dp[amount] if finite, else -1.

            Time: O(amount × coins) | Space: O(amount)

            Key insight: The subproblem structure is: the optimal solution for \
            amount i builds on the optimal solution for amount (i - coin). \
            Since we can reuse coins, this is an unbounded knapsack.
            """,
            leetcodeURL: "https://leetcode.com/problems/coin-change/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000021")!,
            title: "Longest Increasing Subsequence",
            category: .dpMath,
            difficulty: .medium,
            problem: """
            Given an integer array `nums`, return the length of the longest strictly \
            increasing subsequence.

            Example:
              Input:  nums = [10,9,2,5,3,7,101,18]
              Output: 4  ([2,3,7,101])
            """,
            hint: """
            DP: dp[i] = length of LIS ending at index i. \
            For O(n log n): use patience sorting / binary search on a tails array.
            """,
            solution: """
            Pattern A (O(n²) DP):
              dp[i] = 1 + max(dp[j]) for all j < i where nums[j] < nums[i].
              Answer = max(dp).

            Pattern B (O(n log n) — Patience Sorting):
              Maintain tails[] where tails[i] = smallest tail of all increasing
              subsequences of length i+1.
              For each num:
                - Binary search for the leftmost index in tails where tails[i] >= num.
                - Replace tails[index] with num (or append if num is largest).
              Answer = len(tails).

            Time: O(n log n) | Space: O(n)

            Key insight: tails is always sorted, enabling binary search. \
            Replacing elements doesn't change the length but keeps future \
            subsequences as extendable as possible.
            """,
            leetcodeURL: "https://leetcode.com/problems/longest-increasing-subsequence/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000022")!,
            title: "Word Break",
            category: .dpMath,
            difficulty: .medium,
            problem: """
            Given a string `s` and a dictionary of strings `wordDict`, return true if `s` \
            can be segmented into a space-separated sequence of one or more dictionary words.

            Example:
              Input:  s = "leetcode", wordDict = ["leet","code"]
              Output: true
            """,
            hint: """
            dp[i] = true if s[0..i) can be segmented. For each position, \
            check all words ending at i.
            """,
            solution: """
            Pattern: Bottom-Up DP

            1. dp = bool array of size n+1; dp[0] = true.
            2. For i from 1 to n:
               For each word in wordDict:
                 If i >= word.length and dp[i - word.length] and s ends with word at i:
                   dp[i] = true; break.
            3. Return dp[n].

            Time: O(n × m × k) where m = dict size, k = avg word length | Space: O(n)

            Key insight: dp[i] being true means we found a valid segmentation up to i. \
            We can then use i as a starting point to extend the segmentation further.
            """,
            leetcodeURL: "https://leetcode.com/problems/word-break/"
        ),

        // MARK: Data Structures

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000023")!,
            title: "LRU Cache",
            category: .dataStructures,
            difficulty: .medium,
            problem: """
            Design a data structure that follows the constraints of a Least Recently Used (LRU) \
            cache. Implement LRUCache with capacity, get(key), and put(key, value). \
            Both operations must run in O(1) average time.

            Example:
              LRUCache lRUCache = new LRUCache(2);
              lRUCache.put(1, 1); lRUCache.put(2, 2);
              lRUCache.get(1);  → 1
              lRUCache.put(3, 3);  // evicts key 2
              lRUCache.get(2);  → -1 (not found)
            """,
            hint: """
            Combine a doubly-linked list (to track recency order) and a hash map \
            (for O(1) lookup). The list head = most recent, tail = least recent.
            """,
            solution: """
            Pattern: HashMap + Doubly Linked List

            Structure: head ↔ node1 ↔ node2 ↔ ... ↔ tail (sentinels at both ends)
            HashMap: key → ListNode

            get(key):
              If not found: return -1.
              Move node to head (most recent). Return node.value.

            put(key, value):
              If key exists: update value, move to head.
              Else:
                Create new node, insert at head, add to map.
                If size > capacity: remove LRU node (tail.prev), delete from map.

            Time: O(1) all operations | Space: O(capacity)

            Key insight: The doubly linked list provides O(1) move-to-front and \
            remove-from-back. The hash map provides O(1) node lookup. Neither \
            alone is sufficient.
            """,
            leetcodeURL: "https://leetcode.com/problems/lru-cache/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000024")!,
            title: "Implement Trie (Prefix Tree)",
            category: .dataStructures,
            difficulty: .medium,
            problem: """
            A trie (pronounced as "try") or prefix tree is a tree data structure used to \
            efficiently store and retrieve keys in a dataset of strings. Implement a Trie with \
            insert(word), search(word), and startsWith(prefix).

            Example:
              Trie trie = new Trie();
              trie.insert("apple");
              trie.search("apple");    → true
              trie.search("app");      → false
              trie.startsWith("app");  → true
            """,
            hint: """
            Each TrieNode has 26 children (one per letter) and an isEnd flag. \
            Insert by creating nodes as needed; search by traversing.
            """,
            solution: """
            Pattern: Trie data structure

            TrieNode: children[26], isEnd = false.

            insert(word):
              node = root
              for each char: if child doesn't exist, create it; advance to child.
              node.isEnd = true.

            search(word):
              node = traverse(word)
              return node != null and node.isEnd

            startsWith(prefix):
              return traverse(prefix) != null

            traverse(s): follow characters, return nil if path doesn't exist.

            Time: O(m) per operation (m = word length) | Space: O(ALPHABET × N × M)

            Key insight: Unlike hash maps, tries support prefix queries in O(m) time. \
            Shared prefixes use shared nodes, saving memory for large word sets.
            """,
            leetcodeURL: "https://leetcode.com/problems/implement-trie-prefix-tree/"
        ),

        // MARK: JS / Frontend

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000025")!,
            title: "Debounce Function",
            category: .jsFrontend,
            difficulty: .medium,
            problem: """
            Implement a debounce function in JavaScript. A debounced function will delay \
            invoking the provided function until after `wait` milliseconds have elapsed \
            since the last time the debounced function was invoked.

            function debounce(fn, wait) { ... }

            The result function should:
            - Cancel any previous pending call when invoked again within `wait` ms.
            - Pass through all arguments to the original function.
            """,
            hint: """
            Store a timer ID in closure scope. On each call, clear the previous \
            timer and set a new one. The function only fires when the timer completes.
            """,
            solution: """
            Pattern: Closure + setTimeout

            function debounce(fn, wait) {
              let timer;
              return function(...args) {
                clearTimeout(timer);
                timer = setTimeout(() => {
                  fn.apply(this, args);
                }, wait);
              };
            }

            Key points:
            - clearTimeout() is safe to call with undefined or expired IDs.
            - Use fn.apply(this, args) to preserve the calling context.
            - Throttle is similar but fires at the START of the interval instead.

            Use case: Search-as-you-type (wait for user to stop typing before firing API call).
            """,
            leetcodeURL: "https://leetcode.com/problems/debounce/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000026")!,
            title: "Flatten Deeply Nested Array",
            category: .jsFrontend,
            difficulty: .medium,
            problem: """
            Given a multi-dimensional array `arr` and a depth `n`, return a flattened version \
            of that array. A flattened array is a version of that array with some or all of \
            the sub-arrays removed and replaced with the actual elements in that sub-array. \
            Only flatten up to `n` levels deep.

            Example:
              arr = [1, [2, [3, [4]]], [[5]]], n = 2
              Output: [1, 2, 3, [4], 5]
            """,
            hint: """
            Recursive DFS: for each element, if it's an array and depth > 0, \
            recurse with depth-1. Otherwise push the element directly.
            """,
            solution: """
            Pattern: Recursive DFS with depth tracking

            function flat(arr, n) {
              const result = [];
              for (const item of arr) {
                if (Array.isArray(item) && n > 0) {
                  result.push(...flat(item, n - 1));
                } else {
                  result.push(item);
                }
              }
              return result;
            }

            Iterative approach using a stack: push items with remaining depth;
            pop and either flatten or add to result.

            Time: O(total elements) | Space: O(depth) recursion stack

            Key insight: The depth parameter acts as a budget. Once exhausted, \
            nested arrays are treated as leaf values even if they contain arrays.
            """,
            leetcodeURL: "https://leetcode.com/problems/flatten-deeply-nested-array/"
        ),

        // MARK: System Design

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000027")!,
            title: "Design a URL Shortener",
            category: .systemDesign,
            difficulty: .medium,
            problem: """
            Design a URL shortening service like bit.ly.

            Requirements:
            • Given a long URL, return a short URL (e.g. short.ly/abc123).
            • Redirect short URL → original URL.
            • Handle 100M URLs, 10:1 read/write ratio, 100ms p99 redirect latency.
            • URLs should not expire unless explicitly set.

            Discuss: encoding strategy, storage, cache, scalability.
            """,
            hint: """
            Clarify scale. Think about: hash/encode function, collision handling, \
            DB schema, caching hot URLs, and horizontal scaling.
            """,
            solution: """
            Key Design Decisions:

            1. Encoding: Base62 encode a counter or hash(URL). 7 chars → 62^7 = ~3.5T URLs.
               Counter approach: atomic DB sequence; avoids collisions but sequential/predictable.
               Hash approach: MD5/SHA256 first 7 chars; need collision detection.

            2. Storage: KV store (Redis) for short→long mapping.
               SQL or NoSQL for metadata (created_at, user_id, expiry).

            3. Redirect flow:
               GET /abc123 → check cache → if miss: DB lookup → 301/302 redirect.
               301 (permanent): browser caches, reduces server load.
               302 (temporary): every redirect hits server (better for analytics).

            4. Cache: Redis with LRU eviction. Cache the top 20% (Pareto principle).

            5. Scalability: Stateless app servers behind load balancer.
               DB read replicas for the 10:1 read ratio.
               CDN for global latency.

            6. Rate limiting: Token bucket per IP to prevent abuse.
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/system-design"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000028")!,
            title: "Design a News Feed (Facebook / Twitter)",
            category: .systemDesign,
            difficulty: .hard,
            problem: """
            Design a social media news feed system.

            Requirements:
            • Users can post updates (text, images).
            • Each user follows other users.
            • Viewing a feed shows the most recent posts from followed users.
            • Handle 500M DAU, 300 posts/second write, 1M feed reads/second.

            Discuss: fanout strategy, storage, ranking, real-time updates.
            """,
            hint: """
            The core tradeoff is fanout-on-write vs fanout-on-read. \
            Consider celebrity users (high follower count) vs regular users separately.
            """,
            solution: """
            Key Design Decisions:

            1. Fanout-on-write (push model):
               On post: write to all followers' feed caches immediately.
               Pro: fast read. Con: expensive for celebrities (Lady Gaga → 100M writes).

            2. Fanout-on-read (pull model):
               On feed request: fetch posts from all followed users, merge/sort.
               Pro: no write amplification. Con: slow read (fan-in at read time).

            3. Hybrid: Fanout-on-write for regular users; fanout-on-read for celebrities.
               Detect celebrities by follower count threshold.

            4. Storage:
               Posts: DB (e.g. Cassandra partitioned by user_id + timestamp).
               Feed cache: Redis sorted set (score = timestamp) per user.
               Media: Object store (S3) + CDN.

            5. Ranking: Simple chronological vs ML-based engagement scoring.

            6. Real-time: WebSockets or SSE for live updates; fallback to polling.
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/system-design"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000029")!,
            title: "Design a Distributed Cache (Redis-like)",
            category: .systemDesign,
            difficulty: .hard,
            problem: """
            Design a distributed in-memory cache system similar to Redis or Memcached.

            Requirements:
            • get(key), set(key, value, ttl), delete(key).
            • Support 1M ops/second, sub-millisecond latency.
            • Data should survive single-node failure.
            • Support horizontal scaling to add capacity.

            Discuss: data distribution, eviction, replication, consistency.
            """,
            hint: """
            Think about: consistent hashing for distribution, replication factor \
            for fault tolerance, LRU/LFU for eviction, and when to persist to disk.
            """,
            solution: """
            Key Design Decisions:

            1. Data Distribution: Consistent hashing with virtual nodes.
               Maps keys to nodes; adding/removing a node only remaps ~1/N keys.

            2. Replication: Each key stored on N nodes (default N=3).
               Primary handles writes; replicas serve reads (eventual consistency).
               Leader election via Raft/Paxos for strong consistency variant.

            3. Eviction Policies:
               LRU (Least Recently Used): good general-purpose default.
               LFU (Least Frequently Used): better for skewed access patterns.
               TTL-based expiration via background sweep or lazy expiration on read.

            4. Persistence (optional): AOF (Append Only File) logs every write.
               RDB snapshots for faster restart at cost of some data loss.

            5. Client: Connection pooling, consistent hashing client-side or proxy.

            6. Monitoring: Eviction rate, hit/miss ratio, memory usage per node.
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/system-design"
        ),

        // MARK: Behavioral

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000030")!,
            title: "Tell Me About Yourself",
            category: .behavioral,
            difficulty: .easy,
            problem: """
            The classic opening question in most interviews. \
            "Tell me about yourself" or "Walk me through your resume."

            This is your chance to make a strong first impression and frame \
            the conversation in your favor.
            """,
            hint: """
            Structure: Present → Past → Future. Keep it to 2 minutes. \
            Tailor it to the role. End with why you're excited about this company.
            """,
            solution: """
            Framework: Present → Past → Future (The "Tell Me About Yourself" Arc)

            PRESENT (30s): Current role and most relevant accomplishment.
            "I'm currently a senior engineer at Acme, where I lead the payments \
            infrastructure team and recently scaled our checkout flow to handle 10x traffic."

            PAST (45s): 1-2 key experiences that built relevant skills.
            "Before that I was at StartupX, where I built our recommendation engine \
            from scratch — that's where I developed deep expertise in distributed systems."

            FUTURE (30s): Why this company/role excites you specifically.
            "I'm looking to work on problems at even greater scale, and what excites me \
            about this role at [Company] is the challenge of [specific thing you researched]."

            Tips:
            • Practice until it sounds natural, not rehearsed.
            • Customize the "future" section for each company.
            • Avoid just reading your resume chronologically.
            • Invite follow-up: "Happy to dive into any of those."
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/behavioral"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000031")!,
            title: "Describe a Conflict with a Colleague",
            category: .behavioral,
            difficulty: .medium,
            problem: """
            "Tell me about a time you had a conflict with a coworker or manager. \
            How did you handle it?"

            Interviewers want to assess: emotional intelligence, communication skills, \
            professionalism, and ability to collaborate under pressure.
            """,
            hint: """
            Use STAR format. Choose a real example where YOU drove a positive resolution. \
            Avoid blaming others — show empathy and growth.
            """,
            solution: """
            Framework: STAR (Situation, Task, Action, Result)

            SITUATION: Set context briefly — what was the project, who was involved?
            "Our team was building a new API. I disagreed with a senior engineer \
            about the approach to error handling."

            TASK: What was at stake?
            "We needed to ship in 2 weeks and the disagreement was blocking architecture."

            ACTION (the most important part):
            • I requested a 1:1 to understand their perspective first.
            • I prepared a written comparison of both approaches with trade-offs.
            • We agreed on a spike (time-boxed prototype) to test both approaches.
            • I was willing to be wrong — and ended up incorporating their feedback.

            RESULT: Quantify if possible.
            "We shipped on time. The combined approach reduced error handling boilerplate \
            by 40%. We've since co-authored the team's error handling guidelines."

            Key signals: self-awareness, listening first, data-driven resolution, positive outcome.
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/behavioral"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000032")!,
            title: "Describe Your Biggest Technical Failure",
            category: .behavioral,
            difficulty: .medium,
            problem: """
            "Tell me about a time you made a significant technical mistake or \
            a project you failed. What happened and what did you learn?"

            This tests: accountability, self-awareness, resilience, and learning mindset.
            """,
            hint: """
            Pick a real failure — not a humble-brag. Show ownership, \
            concrete lessons learned, and what you changed afterward.
            """,
            solution: """
            Framework: STAR + explicit "What I'd Do Differently"

            SITUATION: Describe the project and what went wrong.
            "I was leading the migration of our monolith to microservices. \
            I underestimated the complexity of distributed transactions."

            TASK: What were you responsible for?
            "I owned the technical design and timeline estimation."

            ACTION (what you did during and after):
            • During: Detected the issue 3 weeks in; immediately raised the flag to leadership.
            • Called a team retrospective to diagnose root cause (not to assign blame).
            • Re-scoped the project with a more iterative approach.

            RESULT:
            "We delayed the launch by 6 weeks. The eventual system was more robust. \
            The failure became a case study used in our onboarding program."

            LEARNING (critical — don't skip):
            "I learned to always validate distributed transaction assumptions with a \
            small proof-of-concept before committing to a timeline. I now require \
            explicit 'unknowns' sections in all my design docs."

            What NOT to do: minimize the failure, blame others, or pick a non-failure.
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/behavioral"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000033")!,
            title: "Why Do You Want to Work Here?",
            category: .behavioral,
            difficulty: .easy,
            problem: """
            "Why do you want to work at [Company]?" or \
            "Why are you leaving your current role?"

            This tests: genuine motivation, research effort, and cultural fit.
            """,
            hint: """
            Research the company deeply. Connect their specific mission/product/tech \
            to your genuine interests. Avoid clichés like "great culture" or "top company."
            """,
            solution: """
            Framework: 3-Part Answer

            1. PULL (what draws you TO this company — most important):
               Be specific to the company. Options:
               • A product/feature you use and find genuinely interesting.
               • A specific engineering challenge (scale, reliability, AI integration).
               • A specific team's work you've read about (blog posts, talks, papers).
               • Their approach to engineering culture (open source, eng blog, values).

            "I've been following [Company]'s work on [specific technology] since reading \
            [specific blog post/talk]. The problem of [specific technical challenge] is \
            exactly the kind of work I want to be doing."

            2. ALIGNMENT (why your background fits):
               Connect your experience to their needs.
            "My 3 years working on distributed systems at Acme maps well to the \
            infrastructure challenges your team is tackling."

            3. PUSH (why you're open to new opportunities — optional, keep brief):
               Frame positively. "I've accomplished X at my current role and I'm \
               looking for the next challenge."

            Red flags to avoid: "You pay well," "You're a big name," "I need a job."
            """,
            leetcodeURL: "https://leetcode.com/discuss/study-guide/behavioral"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000034")!,
            title: "Container With Most Water",
            category: .arrays,
            difficulty: .medium,
            problem: """
            You are given an integer array `height` of length n. There are n vertical lines \
            drawn such that the two endpoints of the ith line are (i, 0) and (i, height[i]). \
            Find two lines that together with the x-axis form a container that holds the most water. \
            Return the maximum amount of water a container can store.

            Example:
              Input:  height = [1,8,6,2,5,4,8,3,7]
              Output: 49
            """,
            hint: """
            Use two pointers from both ends. Move the pointer with the shorter height \
            inward — moving the taller one can never increase the area.
            """,
            solution: """
            Pattern: Two Pointers (Greedy)

            1. lo = 0, hi = n-1, maxWater = 0.
            2. While lo < hi:
               width = hi - lo
               water = min(height[lo], height[hi]) * width
               maxWater = max(maxWater, water)
               if height[lo] < height[hi]: lo++
               else: hi--
            3. Return maxWater.

            Time: O(n) | Space: O(1)

            Proof of correctness: If we move the taller pointer, the width shrinks \
            AND the height can only be ≤ the current shorter height (the shorter \
            pointer hasn't moved). So the area can only decrease or stay the same. \
            Therefore, we can safely discard that state.
            """,
            leetcodeURL: "https://leetcode.com/problems/container-with-most-water/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000035")!,
            title: "Valid Parentheses",
            category: .stacksStrings,
            difficulty: .easy,
            problem: """
            Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', \
            determine if the input string is valid. An input string is valid if:
            • Open brackets must be closed by the same type of brackets.
            • Open brackets must be closed in the correct order.
            • Every close bracket has a corresponding open bracket.

            Example:
              Input:  s = "()[]{}"  → true
              Input:  s = "(]"      → false
            """,
            hint: """
            Stack: push open brackets. On a close bracket, check if the top \
            of the stack is the matching opener.
            """,
            solution: """
            Pattern: Stack

            1. mapping = {')': '(', '}': '{', ']': '['}
            2. stack = []
            3. For each char c in s:
               - If c is an opener ('(', '{', '['): stack.push(c)
               - If c is a closer:
                   if stack is empty or stack.top() != mapping[c]: return false
                   stack.pop()
            4. Return stack.isEmpty()

            Time: O(n) | Space: O(n)

            Key insight: A stack naturally models the LIFO nesting requirement. \
            The string is valid iff every closer matches the most recent unmatched \
            opener (top of stack) AND no openers are left at the end.
            """,
            leetcodeURL: "https://leetcode.com/problems/valid-parentheses/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000036")!,
            title: "Climbing Stairs",
            category: .dpMath,
            difficulty: .easy,
            problem: """
            You are climbing a staircase. It takes n steps to reach the top. Each time you can \
            climb 1 or 2 steps. In how many distinct ways can you climb to the top?

            Example:
              Input:  n = 3
              Output: 3  (1+1+1, 1+2, 2+1)
            """,
            hint: """
            This is the Fibonacci sequence in disguise. \
            ways(n) = ways(n-1) + ways(n-2).
            """,
            solution: """
            Pattern: Dynamic Programming (Fibonacci variant)

            Observation: to reach step n, you either came from step n-1 (one step) \
            or step n-2 (two steps). So ways(n) = ways(n-1) + ways(n-2).

            Iterative (O(1) space):
              a, b = 1, 1
              For i from 2 to n: a, b = b, a + b
              Return b.

            Time: O(n) | Space: O(1)

            Generalization: If you can take 1, 2, ..., k steps, the recurrence \
            becomes ways(n) = sum of ways(n-1) through ways(n-k).
            """,
            leetcodeURL: "https://leetcode.com/problems/climbing-stairs/"
        ),

        Card(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000037")!,
            title: "Validate Binary Search Tree",
            category: .treesGraphs,
            difficulty: .medium,
            problem: """
            Given the root of a binary tree, determine if it is a valid binary search tree (BST).
            A valid BST requires:
            • The left subtree of a node contains only nodes with keys less than the node's key.
            • The right subtree contains only nodes with keys greater than the node's key.
            • Both the left and right subtrees are also valid BSTs.

            Example:
              Input:  [5,1,4,null,null,3,6]
              Output: false (node 4's right child 3 violates BST: 3 < 5)
            """,
            hint: """
            Pass min/max bounds down the recursion. Each node must satisfy \
            min < node.val < max. Update bounds as you go left/right.
            """,
            solution: """
            Pattern: DFS with valid range (min, max bounds)

            isValid(node, min=-∞, max=+∞):
              if node == null: return true
              if node.val <= min or node.val >= max: return false
              return isValid(node.left, min, node.val)
                 and isValid(node.right, node.val, max)

            Common mistake: only checking left.val < root.val < right.val is WRONG. \
            A deeper left-subtree node can violate the BST invariant with respect to \
            an ancestor.

            Time: O(n) | Space: O(h) — h = tree height

            Alternatively: In-order traversal of a BST produces a sorted sequence. \
            Verify the in-order traversal is strictly increasing.
            """,
            leetcodeURL: "https://leetcode.com/problems/validate-binary-search-tree/"
        )
    ]
}
