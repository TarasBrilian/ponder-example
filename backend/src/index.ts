import { ponder } from "ponder:registry";
import schema from "ponder:schema";

ponder.on("ERC20:Transfer", async ({ event, context }) => {
  await context.db
    .insert(schema.account)
    .values({ address: event.args.from, balance: 0n, isOwner: false })
    .onConflictDoUpdate((row) => ({
      balance: row.balance - event.args.value,
    }));

  await context.db
    .insert(schema.account)
    .values({ address: event.args.to, balance: 0n, isOwner: false })
    .onConflictDoUpdate((row) => ({
      balance: row.balance + event.args.value,
    }));

  // add row to "transfer_event".
  await context.db.insert(schema.transferEvent).values({
    id: event.id,
    amount: event.args.value,
    timestamp: Number(event.block.timestamp),
    from: event.args.from,
    to: event.args.to,
  });
});

ponder.on("ERC20:Approval", async ({ event, context }) => {
  // upsert "allowance".
  await context.db
    .insert(schema.allowance)
    .values({
      spender: event.args.spender,
      owner: event.args.owner,
      amount: event.args.value,
    })
    .onConflictDoUpdate({ amount: event.args.value });

  // add row to "approval_event".
  await context.db.insert(schema.approvalEvent).values({
    id: event.id,
    amount: event.args.value,
    timestamp: Number(event.block.timestamp),
    owner: event.args.owner,
    spender: event.args.spender,
  });
});

ponder.on("VaultContract:Deposit", async ({ event, context }) => {
  await context.db
    .insert(schema.depositEvents)
    .values({
      id: `${event.transaction.hash}-${event.log.logIndex}`,
      user: event.args.user,
      amount: event.args.amount,
      shares: event.args.shares,
      blockNumber: event.block.number,
      timestamp: event.block.timestamp,
    });
});

ponder.on("VaultContract:Withdraw", async ({ event, context }) => {
  await context.db
    .insert(schema.withdrawEvents)
    .values({
      id: `${event.transaction.hash}-${event.log.logIndex}`,
      user: event.args.user,
      amount: event.args.amount,
      shares: event.args.shares,
      blockNumber: event.block.number,
      timestamp: event.block.timestamp,
    });
})