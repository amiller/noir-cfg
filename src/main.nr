/*
 bb: c, b: cc
Rules:
   S, Ac, A
   Ac, A, C
   A, a, 0
   B, b, 0
   C, c, 0
   Bc, B, C
 */
/*
[S]          0, 0
[ Ac A ]     1, 0  [ Ac->1 A ] 
[ A C A]     6, 2  [ Ac->2 A C ]
[ A C Bc C ] 4, 3
[ A C Bc c ] 5, 2
[ A C B C c ]4, 3
[ a C B C c ]3, 2
[ a C b C c ]2, 0
[ a C b c c ]4, 1
[ a c b c c ]
 */

global N = 3;

global S = 1;
global Ac = 2;
global Bc = 3;
global A = 4;
global B = 5;
global C = 6;
global a = 7;
global b = 8;
global c = 9;

global rules = [
    (S, Ac, A),  //0 
    (Ac, A, C),  //1
    (A, a, 0),   //2
    (B, b, 0),   //3
    (C, c, 0),   //4
    (Bc, B, C),  //5
    (A, Bc, C)]; //6

struct Node {
    next: Field,
    val: Field
}

fn main(string: [Field; N], apps: [(Field,Field); 2*N-1]) {

    // Start with Start symbol    
    let mut list = [Node{next:-1,val:0}; 2*N-1];
    list[0].val = S;
    let mut listHead = 0; // Start of list
    let mut listNext = 1; // next unallocated node

    // Apply rules
    for rl in apps {
	let (rule, loc) = rl;
	let (nt, ntL, ntR) = rules[rule];
	// check rule applies to correct non terminal
	assert(list[loc].val == nt);
	
	if (ntR == 0) { // NT to T
	    // Replace in place
	    list[loc].val = ntL;
	} else { // NT to (NT,NT)
	    
	    // Add a new node to the end
	    list[listNext].val = ntR;
	    list[loc].val = ntL;
	    
	    // New node points to the next.
	    // Modify current node to point to new one
	    list[listNext].next = list[loc].next;
	    list[loc].next = listNext;
	    listNext += 1;
	}
    }

    // Check final string matches
    let mut cur = listHead;
    for i in 0..N {
	assert(string[i] == list[cur].val);
	cur = list[cur].next;
    }
    assert(cur == -1);
    
}

#[test]
fn test_main() {
    main([a, c, a], // [S]
	 [(0,0),   // [Ac, A]
	  (1,0),   // [A, A, C]
	  (2,0), (2,1), (4,2) ]
/*	 [(0, 0),
	  (1, 0),
	  (6, 2),
	  (4, 3),
	  (5, 2),
	  (4, 3),
	  (3, 2),
	  (2, 0),
	  (4, 1)]*/);
}
